How to call:

./handler.rb 'Add Tom 4111111111111111 $1000
Add Lisa 5454545454545454 $3000
Add Quincy 1234567890123456 $2000
Charge Tom $500.50
Charge Tom $800.80
Charge Lisa $7.01
Credit Lisa $100.54
Credit Quincy $200.12'

Note that it must have ' not " to prevent bash interpretation of $.



Result:

Processing...
Error:  Add Quincy 1234567890123456 $2000 -> Card number does not have valid Luhn 10 checksum
Error:  Charge Tom $800.80 -> Credit limit exceeded; charge declined
Error:  Credit Quincy $200.12 -> Card not found

Done!
Lisa: $93.53
Tom: $-500.50



Places where I disagree with the proposed model and have implemented something different:

1. Positive balance = credit, negative balance = debt. "Credit limit" is the most negative amount an account can be in.
2. Faulty cards should not be saved, but rather rejected immediately to be dealt with as appropriate.
3. All errors should be shown immediately and explain their source. Provided example silently discards two errors.
4. Card balance is stored in cents, not dollars. Prevents floating point errors and allows handling of cents.
   IRL you might use microcents or the like if you're not rounding to the nearest cent.



Text of challenge:

Basic Credit Card Processing
----------------------------

Imagine that you're writing software for a credit card provider.  Implement a program that will add new credit card accounts, process charges and credits against them, and display summary information.

Requirements:
- three input commands must be handled, passed with space delimited arguments
  - "Add" will create a new credit card for a given name, card number, and limit
    - Card numbers should be validated using Luhn 10
    - New cards start with a $0 balance
  - "Charge" will increase the balance of the card associated with the provided name by the amount specified
    - Charges that would raise the balance over the limit are ignored as if they were declined
    - Charges against Luhn 10 invalid cards are ignored
  - "Credit" will decrease the balance of the card associated with the provided name by the amount specified
    - Credits that would drop the balance below $0 will create a negative balance
    - Credits against Luhn 10 invalid cards are ignored
- when all input has been read and processed, a summary should be generated
  - the summary should include the name of each person followed by a colon and balance
  - the names should be displayed alphabetically
  - display "error" instead of the balance if the credit card number does not pass Luhn 10

Input Assumptions:
- all input will be space delimited
- credit card numbers may vary in length, up to 19 characters
- credit card numbers will always be numeric
- amounts will always be prefixed with "$" and will be in whole dollars (no decimals)

Example Input:

Add Tom 4111111111111111 $1000
Add Lisa 5454545454545454 $3000
Add Quincy 1234567890123456 $2000
Charge Tom $500
Charge Tom $800
Charge Lisa $7
Credit Lisa $100
Credit Quincy $200

Example Output:

Lisa: $-93
Quincy: error
Tom: $500

Please provide your solution in any programming language. If you write tests, please include them with your submission.