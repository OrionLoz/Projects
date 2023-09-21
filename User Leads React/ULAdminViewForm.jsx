import React, { useEffect, useState } from "react";
import userLeadService from "services/userLeadsService";
import toastr from "toastr";
import debug from "MoneFi-debug";
import "./userleadsstyle.css";
import Pagination from "rc-pagination";
import locale from "rc-pagination/lib/locale/en_US";
import "rc-pagination/assets/index.css";
import Modal from "react-bootstrap/Modal";
import Button from "react-bootstrap/Button";
import lookUpService from "services/lookUpService";

const _logger = debug.extend("UserLeadAdminLogger");

const UserLeadAdminView = () => {
  //#region State
  const [userLeads, setUserLeads] = useState([]);
  const [status, setStatus] = useState(null);
  const [selectedStatus, setSelectedStatus] = useState();
  const [selectedLeadId, setSelectedLeadId] = useState(null);
  const [updatedNotes, setUpdatedNotes] = useState("");

  const [modals, setModals] = useState({
    showNotesModal: false,
    showStatusModal: false,
  });
  const [pageData, setPageData] = useState({
    pageIndex: 0,
    totalCount: 0,
    pageSize: 10,
  });
  //#endregion

  //#region Toastr Options
  toastr.options = {
    newestOnTop: true,
    progressBar: true,
    positionClass: "toast-top-right",
    preventDuplicates: true,
    showDuration: "250",
    hideDuration: "900",
    timeOut: "3000",
    extendedTimeOut: "600",
    showEasing: "swing",
    hideEasing: "linear",
    showMethod: "fadeIn",
    hideMethod: "fadeOut",
  };
  //#endregion

  //#region UseEffects
  useEffect(() => {
    userLeadService
      .selectAll(pageData.pageIndex, pageData.pageSize)
      .then(onSuccess)
      .catch(onError);
  }, [pageData.pageIndex]);

  useEffect(() => {
    lookUpService
      .getTypes(["StatusTypes"])
      .then(onGetTypesSuccess)
      .catch(onGetTypesError);
  }, []);
  //#endregion

  //#region Status Types Mapping
  const mappedStatusTypes = (response) => {
    var result = response.item.statusTypes.map((statusTypes) => (
      <option key={statusTypes.id} value={statusTypes.id}>
        {statusTypes.name}
      </option>
    ));
    return result;
  };
  //#endregion

  //#region Modal Handlers
  const openNotesModal = (leadId, notes) => {
    setSelectedLeadId(leadId);
    setUpdatedNotes(notes);
    setModals({ showStatusModal: false, showNotesModal: true });
  };

  const openStatusModal = (leadId, statusId) => {
    setSelectedLeadId(leadId);
    setSelectedStatus(statusId);
    setUpdatedNotes(updatedNotes);
    setModals({ showNotesModal: false, showStatusModal: true });
  };

  const closeModal = () => {
    setModals({ showStatusModal: false, showNotesModal: false });
  };
  //#endregion

  //#region Success/Error Handlers
  const onSuccess = (response) => {
    const mappedUserLeads = (response) => {
      return response.item.pagedItems.map((lead) => leadTableTemplate(lead));
    };
    const userLeadsMapped = mappedUserLeads(response);
    setUserLeads(userLeadsMapped);
    setPageData((prevPageData) => ({
      ...prevPageData,
      totalCount: response.item.totalCount,
    }));
  };

  const onError = (error) => {
    toastr.error("Error fetching User Leads");
    _logger("Error fetching User Leads", error);
  };

  const onUpdateStatusSuccess = () => {
    toastr.success("Successfully updated status");
    _logger("Successfully updated status");
  };

  const onUpdateStatusError = (error) => {
    toastr.error("Error updating Status");
    _logger("Error updating Status", error);
  };

  const onUpdateNotesSuccess = () => {
    toastr.success("Successfully updated notes");
    _logger("Successfully updated notes");
  };

  const onUpdateNotesError = (error) => {
    toastr.error("Error updating notes");
    _logger("Error updating notes", error);
  };

  const onGetTypesSuccess = (response) => {
    _logger("Response", response);
    const statusTypeOptions = mappedStatusTypes(response);
    setStatus(statusTypeOptions);
  };

  const onGetTypesError = (error) => {
    _logger("Error fetching Loan Types", error);
  };
  //#endregion

  //#region Update Handlers
  const handleUpdateStatus = () => {
    userLeadService
      .updateStatus(selectedLeadId, selectedStatus)
      .then((response) => {
        closeModal();
        onUpdateStatusSuccess(response);
        userLeadService
          .selectAll(pageData.pageIndex, pageData.pageSize)
          .then(onSuccess)
          .catch(onError);
      })
      .catch(onUpdateStatusError);
  };

  const handleUpdateNotes = () => {
    userLeadService
      .updateNotes(selectedLeadId, updatedNotes)
      .then((response) => {
        closeModal();
        onUpdateNotesSuccess(response);
        userLeadService
          .selectAll(pageData.pageIndex, pageData.pageSize)
          .then(onSuccess)
          .catch(onError);
      })
      .catch(onUpdateNotesError);
  };
  //#endregion

  const onPaginationClick = (pageNumber) => {
    _logger("pageNumber", pageNumber);
    setPageData((prevState) => ({
      ...prevState,
      pageIndex: pageNumber - 1,
    }));
  };

  const leadTableTemplate = (lead) => (
    <tr key={lead.id}>
      <td>{lead.id}</td>
      <td>{lead.email}</td>
      <td>{`${lead.firstName} ${lead.lastName}`}</td>
      <td>{lead.loanAmount}</td>
      <td>{lead.loanType.name}</td>
      <td>
        <button
          className="pill-button"
          onClick={() => openStatusModal(lead.id)}
        >
          {lead.statusType.name}
        </button>
      </td>
      <td>{new Date(lead.dateCreated).toLocaleDateString()}</td>
      <td>{new Date(lead.dateModified).toLocaleDateString()}</td>
      <td>
        <button
          className="pill-button"
          onClick={() => openNotesModal(lead.id, lead.notes)}
        >
          View Notes
        </button>
      </td>
    </tr>
  );

  return (
    <div className="container">
      <h1 className="row admin-heading-style">User Leads</h1>
      <div className="card">
        <table className="table">
          <thead>
            <tr>
              <th scope="col">Id</th>
              <th scope="col">Email</th>
              <th scope="col">Name</th>
              <th scope="col">Loan Amount</th>
              <th scope="col">Loan Type</th>
              <th scope="col">Status</th>
              <th scope="col">Date Created</th>
              <th scope="col">Date Modified</th>
              <th scope="col">Notes</th>
            </tr>
          </thead>
          <tbody>{userLeads}</tbody>
        </table>
        <div className="pagination-container">
          <Pagination
            total={pageData.totalCount}
            current={pageData.pageIndex + 1}
            pageSize={pageData.pageSize}
            onChange={onPaginationClick}
            showLessItems={true}
            locale={locale}
          />
        </div>
      </div>
      <Modal show={modals.showNotesModal} onHide={closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>Edit Notes</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <textarea
            className="form-control notes-field"
            placeholder="Notes"
            value={updatedNotes}
            onChange={(e) => setUpdatedNotes(e.target.value)}
          />
        </Modal.Body>
        <Modal.Footer>
          <Button variant="primary" onClick={handleUpdateNotes}>
            Save Changes
          </Button>
        </Modal.Footer>
      </Modal>

      <Modal show={modals.showStatusModal} onHide={closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>Update Status</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <select
            className="form-select"
            value={selectedStatus}
            onChange={(e) => setSelectedStatus(e.target.value)}
          >
            <option selected>Update Status</option>
            {status}
          </select>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="primary" onClick={handleUpdateStatus}>
            Save Changes
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default UserLeadAdminView;
