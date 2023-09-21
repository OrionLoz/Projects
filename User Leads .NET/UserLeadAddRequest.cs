using System;
using System.ComponentModel.DataAnnotations;

namespace MoneFi.Models.Requests
{
    public class UserLeadAddRequest
    {
        [Required]
        [DataType(DataType.EmailAddress),MaxLength(255)]
        public string Email { get; set; }

        [Required]
        [MinLength(1),MaxLength(100)]
        public string FirstName { get; set; }

        [Required]
        [MinLength(1), MaxLength(100)]
        public string LastName { get; set; }

        [Required]
        [Range(0, (double)Decimal.MaxValue)]
        public decimal LoanAmount { get; set; }

        [Required]
        public int LoanTypeId { get; set; }

        public string Token { get; set; }
      
        public int StatusId { get; set; }
    }
}
