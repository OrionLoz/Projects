using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Sabio.Models;
using Sabio.Models.Domain.UserLeads;
using Sabio.Models.Requests;
using Sabio.Services;
using Sabio.Services.Interfaces;
using Sabio.Web.Controllers;
using Sabio.Web.Models.Responses;
using Stripe;
using System;

namespace Sabio.Web.Api.Controllers
{
    [Route("api/userleads")]
    [ApiController]
    public class UserLeadApiController : BaseApiController
    {
        private IUserLeadService _userLeadService = null;
        private IAuthenticationService<int> _authService = null;
        
        public UserLeadApiController(IUserLeadService service
            , ILogger<UserLeadApiController> logger
            , IAuthenticationService<int> authService) : base(logger)
        {
            _userLeadService = service;
            _authService = authService;
        }

        [HttpGet("{email}")]
        public ActionResult<ItemResponse<UserLeadBase>> Get(string email)
        {
            int iCode = 200;
            BaseResponse response = null;

            try
            {
                UserLeadBase userLead = _userLeadService.Select(email);

                if (userLead == null)
                {
                    iCode = 404;
                    response = new ErrorResponse("Application Resource not found.");
                }
                else
                {
                    response = new ItemResponse<UserLeadBase> { Item = userLead };
                }
            }
            catch (Exception ex)
            {

                iCode = 500;
                Logger.LogError(ex.ToString());
                response = new ErrorResponse($"{ex.Message}");
            }

            return StatusCode(iCode, response);
        }

        [HttpGet("paginate")]
        public ActionResult<ItemResponse<Paged<UserLeadBase>>> GetAll(int pageIndex, int pageSize)
        {
            int code = 200;
            BaseResponse response = null;
            
            try
            {
                Paged<UserLeadBase> page = _userLeadService.Select(pageIndex, pageSize);

                if (page == null)
                {
                    code = 404;
                    response = new ErrorResponse("App Resource not found.");
                }
                else
                {
                    response = new ItemResponse<Paged<UserLeadBase>> { Item = page };
                }
            }
            catch (Exception ex)
            {
                code = 500;
                Logger.LogError(ex.ToString());
                response = new ErrorResponse(ex.Message);
            }


            return StatusCode(code, response);

        }
        
        [HttpPost]
        [AllowAnonymous]
        public ActionResult<ItemResponse<int>> Create(UserLeadAddRequest model)
        {
            ObjectResult result = null;
            try
            {
                int id = _userLeadService.Add(model);
                ItemResponse<int> response = new ItemResponse<int>() { Item = id };

                result = Created201(response);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex.ToString());
                ErrorResponse response = new ErrorResponse(ex.Message);

                result = StatusCode(500, response);
            }
            return result;
        }

        [HttpPut("updateStatus/{id:int}")]
        public ActionResult<SuccessResponse> UpdateStatus(UserLeadStatusUpdateRequest model, int Id)
        {
            int code = 200;
            BaseResponse response = null;

            try
            {
                _userLeadService.UpdateStatus(model, Id);

                response = new SuccessResponse();
            }
            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
            }


            return StatusCode(code, response);
        }

        [HttpPut("updateNotes/{id:int}")]
        public ActionResult<SuccessResponse> UpdateNotes(UserLeadNotesUpdateRequest model, int Id)
        {
            int code = 200;
            BaseResponse response = null;

            try
            {
                _userLeadService.UpdateNotes(model, Id);

                response = new SuccessResponse();
            }
            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
            }


            return StatusCode(code, response);
        }
    }
} 
