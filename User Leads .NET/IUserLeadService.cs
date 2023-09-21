using MoneFi.Models;
using MoneFi.Models.Domain.UserLeads;
using MoneFi.Models.Requests;
using System;

namespace MoneFi.Services
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
