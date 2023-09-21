using Sabio.Models;
using Sabio.Models.Domain.UserLeads;
using Sabio.Models.Requests;
using System;

namespace Sabio.Services
{
    public interface IUserLeadService
    {
        UserLeadBase Select(string email);

        Paged<UserLeadBase> Select(int pageIndex, int pageSize);

        int Add(UserLeadAddRequest model);
        void UpdateStatus(UserLeadStatusUpdateRequest model, int Id);
        void UpdateNotes(UserLeadNotesUpdateRequest model, int Id);
    }
}
