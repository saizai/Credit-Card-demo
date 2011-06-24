class Card
	# Stores holder's credit as positive, debt as negative
	
	def initialize(name, cardnumber, creditlimit = 0)		
		@name = name;
		
		# card numbers are semantically structs but treated for all purposes like strings (e.g. Luhn 10) and could hypothetically have letters
		@cardnumber = cardnumber;
		
		@creditlimit = -creditlimit;
		@balance = 0;
		
		validate!
		
		return self
	end
	
	# Not ideal; e.g. doesn't permit multiple errors simultaneously. But simple at least.
	def validate!
		if @cardnumber.length > 20 
			raise "Card number may not be more than 19 digits long"
		elsif @cardnumber.length < 1
			raise "Card number must have at least one account digit and one checksum digit"
		end
		if @cardnumber.to_i.to_s != @cardnumber # easy hack to ensure only digits
			raise "Card number must contain only digits"
		end
		if @name.length < 1
			raise "Card name must not be blank" 
		end
		if Card.luhn_10(@cardnumber[0..-2]) != @cardnumber[-1..-1].to_i
			raise "Card number does not have valid Luhn 10 checksum"
		end 
	end
	
	# return checksum of this number
	def self.luhn_10 number
		double = true
		10 - number.reverse.split('').map(&:to_i).inject(0) {|sum, digit|
		  add = digit
      add *= 2 if double # double the odds
      double = !double # and flip
	    sum += (add > 9 ? add -= 9 : add) # add the two digits
	  } % 10
	end
	
	def change_balance cents
		if (@balance + cents) < @creditlimit
			raise "Credit limit exceeded; charge declined"
		end
		
    # IRL this would be a rather more complex call, and wrapped in an optimistic DB lock + mutex for other shared resources (eg cache)  
 		@balance += cents
	end
	
	def balance
	  @balance
	end
	
	def status
		 "#{@name}: $#{'%.2f' % (@balance / 100.0)}"
	end 
end