import React, { useEffect, useState } from "react";
import userLeadService from "services/userLeadsService";
import lookUpService from "services/lookUpService";
import { Formik, Form, Field } from "formik";
import debug from "sabio-debug";
import "./userleadsstyle.css";
import toastr from "toastr";
import iphone from "../../assets/images/png/Group289272.png";

const _logger = debug.extend("UserLeadLogger");

function UserLeadForm() {
  const [loanTypes, setLoanTypes] = useState([]);
  var formData = {
    firstName: "",
    lastName: "",
    email: "",
    loanAmount: "",
    loanTypeId: "",
    token: "",
    statusId: 3,
  };

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

  const mappedLoanTypes = (response) => {
    var result = response.item.loanTypes.map((loanTypes) => (
      <option key={loanTypes.id} value={loanTypes.id}>
        {loanTypes.name}
      </option>
    ));
    return result;
  };

  //#region Success/Error Handlers
  const onGetTypesSuccess = (response) => {
    _logger("Response", response);
    const loanTypeOptions = mappedLoanTypes(response);
    setLoanTypes(loanTypeOptions);
  };

  const onGetTypesError = (error) => {
    _logger("Error fetching Loan Types", error);
  };

  useEffect(() => {
    lookUpService
      .getTypes(["LoanTypes"])
      .then(onGetTypesSuccess)
      .catch(onGetTypesError);
  }, []);

  const onSuccess = (response) => {
    toastr.success("Success!");
    _logger("Success!");
    _logger(response);
  };

  const onError = (error) => {
    toastr.error("Error submitting information");
    _logger("Failed");
    _logger(error);
  };
  //#endregion

  const handleSubmit = (values) => {
    userLeadService
      .add({
        ...values,
        statusId: formData.statusId,
      })
      .then(onSuccess)
      .catch(onError);
  };

  const scrollToForm = () => {
    const formSection = document.getElementById("form-section");
    formSection.scrollIntoView({ behavior: "smooth" });
  };

  return (
    <div className="container-fluid user-lead-background">
      <div className="row">
        <div className="col-lg-12 top-page-padding user-lead-background-image">
          <h1 className="heading-style">Apply Now!</h1>
          <h3 className="heading-style">
            Fast Funding for your Business Needs - Get the Capital You Require
            in Just 24 Hours with Our Efficent Process and Expert Team
          </h3>
          <button
            type="button"
            className="btn btn-primary submitButton large-button"
            onClick={scrollToForm}
          >
            Lets Get Started!
          </button>
        </div>
      </div>
      <div className="row">
        <div className="col-lg-6 ">
          <img src={iphone} alt="iphone" className="user-lead-image" />
        </div>
        <div id="form-section" className="col-lg-4 form-padding background">
          <h1 className="form-heading">Ready to Get Started?</h1>
          <Formik
            enableReinitialize={true}
            initialValues={formData}
            onSubmit={handleSubmit}
          >
            <Form>
              <div>
                <label htmlFor="FirstName" className="label-padding ">
                  First Name <span className="text-danger">*</span>
                </label>
                <Field
                  placeholder="First Name"
                  type="text"
                  name="firstName"
                  className="form-control fieldStyle"
                />
              </div>
              <div>
                <label htmlFor="LastName" className="label-padding ">
                  Last Name <span className="text-danger">*</span>
                </label>
                <Field
                  placeholder="Last Name"
                  type="text"
                  name="lastName"
                  className="form-control fieldStyle"
                />
              </div>
              <div>
                <label htmlFor="Email" className="label-padding ">
                  Email <span className="text-danger">*</span>
                </label>
                <Field
                  placeholder="Email"
                  type="email"
                  name="email"
                  className="form-control fieldStyle"
                />
              </div>
              <div>
                <label htmlFor="loanAmount" className="label-padding ">
                  Loan Amount <span className="text-danger">*</span>
                </label>
                <Field
                  placeholder="Loan Amount"
                  type="text"
                  name="loanAmount"
                  className="form-control fieldStyle"
                />
              </div>
              <div>
                <label htmlFor="loanTypeId" className="label-padding ">
                  Loan Type <span className="text-danger">*</span>
                </label>
                <Field
                  as="select"
                  name="loanTypeId"
                  className="form-select fieldStyle"
                  aria-label="Loan Type Select"
                >
                  <option selected>Select One</option>
                  {loanTypes}
                </Field>
              </div>
              <div className="button-spacing">
                <button
                  type="submit"
                  name="submit"
                  className="btn btn-primary submitButton"
                >
                  Submit
                </button>
              </div>
            </Form>
          </Formik>
        </div>
      </div>
    </div>
  );
}

export default UserLeadForm;
