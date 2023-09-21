using MoneFi.Data.Providers;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using MoneFi.Models.Domain;
using MoneFi.Data;
using MoneFi.Models.Requests;
using MoneFi.Models.Domain.UserLeads;
using MoneFi.Models;
using System;
using MoneFi.Services.Interfaces;
using MoneFi.Models.Requests.Blogs;

namespace MoneFi.Services
{
    public class UserLeadService :IUserLeadService
    {
        IDataProvider _data = null;
        ILookUpService _lookUpService = null;
        public UserLeadService(IDataProvider data, ILookUpService lookUpService)
        {
            _data = data;
            _lookUpService = lookUpService;
        }

        public UserLeadBase Select(string email)
        {
            UserLeadBase userLead = null;
            string procName = "[dbo].[UserLeads_Select_ByEmail]";

            _data.ExecuteCmd(procName, delegate (SqlParameterCollection col)
            {
                col.AddWithValue("@Email", email);
            }, delegate (IDataReader reader, short set)
            {
                int startingIndex = 0;
                userLead = UserLeadMapperV2<UserLeadBase>(reader, ref startingIndex, includeToken:true);
            });
            return userLead;
        }

        public Paged<UserLeadBase> Select(int pageIndex, int pageSize)
        {
            Paged<UserLeadBase> pagedList = null;
            List<UserLeadBase> list = null;
            int totalCount = 0;
            string procName = "[dbo].[UserLeads_SelectAll]";

            _data.ExecuteCmd(procName,
                delegate (SqlParameterCollection col)
                {
                    col.AddWithValue("@pageIndex", pageIndex);
                    col.AddWithValue("@pageSize", pageSize);

                }, delegate (IDataReader reader, short set)
                {
                    int startingIndex = 0;
                    UserLeadBase users = UserLeadMapperV2<UserLeadBase>(reader, ref startingIndex);
                    if(totalCount == 0)
                    {
                        totalCount = reader.GetSafeInt32(startingIndex);
                        
                    }
                    if (list == null)
                    {
                        list = new List<UserLeadBase>();
                        
                    }
                    list.Add(users);
                });
            if (list != null)
            {
                pagedList = new Paged<UserLeadBase>(list, pageIndex, pageSize, totalCount);
            }
            return pagedList;
        }
        
        public int Add(UserLeadAddRequest model)
        {
            int id = 0;
            string procName = "[dbo].[UserLeads_Insert]";
            string token = Guid.NewGuid().ToString();
            model.Token = token;
            
            _data.ExecuteNonQuery(procName, inputParamMapper:
                delegate (SqlParameterCollection col)
            {
                AddCommonParams(model, col);

                SqlParameter idOut = new SqlParameter("@Id", SqlDbType.Int);
                idOut.Direction = ParameterDirection.Output;
                col.Add(idOut);
                
            },
            returnParameters: delegate (SqlParameterCollection col)
            {
                id = (int)col["@Id"].Value;
            });
            return id;
        }

        public void UpdateStatus(UserLeadStatusUpdateRequest model, int Id)
        {
            string procName = "[dbo].[UserLeads_UpdateStatus]";

            _data.ExecuteNonQuery(procName, inputParamMapper: delegate (SqlParameterCollection col)
            {
                col.AddWithValue("@Id", Id);
                col.AddWithValue("@StatusId", model.StatusId);
            
            },
            returnParameters: null);
        }

        public void UpdateNotes(UserLeadNotesUpdateRequest model, int Id)
        {
            string procName = "[dbo].[UserLeads_UpdateNotes]";

            _data.ExecuteNonQuery(procName, inputParamMapper: delegate (SqlParameterCollection col)
            {
                col.AddWithValue("@Id", Id);
                col.AddWithValue("@Notes", model.Notes);

            },
            returnParameters: null);
        }



        private static void AddCommonParams(UserLeadAddRequest model, SqlParameterCollection col)
        {
            col.AddWithValue("@Email", model.Email);
            col.AddWithValue("@FirstName", model.FirstName);
            col.AddWithValue("@LastName", model.LastName);
            col.AddWithValue("@LoanAmount", model.LoanAmount);
            col.AddWithValue("@LoanTypeId", model.LoanTypeId);
            col.AddWithValue("@Token", model.Token);
            col.AddWithValue("@StatusId", model.StatusId);
        }

        private T UserLeadMapperV2<T>(IDataReader reader, ref int startingIndex, bool includeToken = false) where T : UserLeadBase, new() 
        {
            T lead = new T ();

            lead.Id = reader.GetSafeInt32(startingIndex++);
            lead.Email = reader.GetSafeString(startingIndex++);
            lead.FirstName = reader.GetSafeString(startingIndex++);
            lead.LastName = reader.GetSafeString(startingIndex++);
            lead.LoanAmount = reader.GetSafeDecimal(startingIndex++);
            lead.LoanType = _lookUpService.MapSingleLookUp(reader, ref startingIndex);
            lead.StatusType = _lookUpService.MapSingleLookUp(reader, ref startingIndex);
            lead.Description = reader.GetSafeString(startingIndex++);
            lead.DateCreated = reader.GetSafeDateTime(startingIndex++);
            lead.DateModified = reader.GetSafeDateTime(startingIndex++);
            lead.Notes = reader.GetSafeString(startingIndex++);

            return lead;
        }
    }  
}
