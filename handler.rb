#!/usr/bin/env ruby
require 'card.rb'

commands = ARGV[0].split("\n")

@cards = {}  # {'alias' => card, ...}

puts "\nProcessing...\n"

def get_card name
  # IRL, names are not globally unique so really really oughtn't be used like this. Instead use some kind of GU account ID.
  # Also, security wise, a merchant oughtn't be able to execute a charge without knowing the account # in one form or another... 
	card = @cards[name] 
	card || raise("Card not found")
end

# would be an entry point for currency conversion etc etc IRL
def textamount_to_cents text
	text[1..-1].to_f * 100
end

commands.each {|command|
  args = command.split(' ')
  
  begin
    case args[0]
      when 'Add'
        @cards[args[1]] = Card.new(args[1], args[2], textamount_to_cents(args[3]))
      when 'Charge' 
        card = get_card(args[1])
        card.change_balance -textamount_to_cents(args[2])
      when 'Credit'
        card = get_card(args[1])
        card.change_balance textamount_to_cents(args[2])
      else
        raise "Unknown command"
    end
  rescue RuntimeError => error
    puts "Error:  #{command} -> #{error}"
  end
}

puts "\nDone!\n"

puts @cards.sort.map{|name, card| card.status }

  # - "Charge" will increase the balance of the card associated with the provided name by the amount specified
    # - Charges that would raise the balance over the limit are ignored as if they were declined
    # - Charges against Luhn 10 invalid cards are ignored
  # - "Credit" will decrease the balance of the card associated with the provided name by the amount specified
    # - Credits that would drop the balance below $0 will create a negative balance
    # - Credits against Luhn 10 invalid cards are ignored
# 
    # - when all input has been read and processed, a summary should be generated
  # - the summary should include the name of each person followed by a colon and balance
  # - the names should be displayed alphabetically
  # - display "error" instead of the balance if the credit card number does not pass Luhn 10
# 
# Input Assumptions:
# - all input will be space delimited
# - amounts will always be prefixed with "$" and will be in whole dollars (no decimals)
