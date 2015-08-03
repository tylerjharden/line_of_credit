class LineOfCredit
	attr_accessor :limit, :apr
	attr_reader :available_credit, :principal, :transactions	
	
	@@payment_period = 30 # 30 day payment periods
	
	def initialize limit, apr
		@limit = limit
		@available_credit = limit
		@apr = apr
		@principal = 0
		@transactions = {}
	end
	
	# Debits are positive amounts, credits are negative amounts
	def record_transaction amount = 0, day = 0
		# Add amount to the transaction total for the day, such that multiple transactions
		# on the same day will balance out (if equal and opposite
		if (transactions[day] == nil)
			transactions[day] = amount
		else		
			transactions[day] += amount
		end
	end
	
	# Make a debit against credit limit, increasing principal
	def draw amount, day = 0
		if (amount <= @available_credit)
			@available_credit -= amount
			@principal += amount
			record_transaction(amount, day)
		end
	end
	
	# Make a payment on the principal balance
	def make_payment amount, day = 0
		if (amount <= principal)
			@available_credit += amount
			@principal -= amount
			record_transaction(-amount, day)
		end
	end
	
	def calculate_total_due
		interest_due = 0 # start off with no interest
		last_day = 0 # the last transaction that changed principal amount
		last_amount = 0 # the amount of last transaction
		principal = 0 # current principal after applying current transaction 
		last_principal = 0 # the principal being carried since last transaction
		
		# For continuity, add a "0" amount transaction at end of pay period if non-existant
		@transactions[@@payment_period] = @transactions[@@payment_period] || 0 # zero out the day of calculation if non-existent
	
		# Loop through this payment period's transactions
		for i in 0..@@payment_period
			transaction = @transactions[i] # Grab current iterations transaction
			
			if (transaction == nil)
				next #skip days where no transaction occurred 
			else
				principal += transaction # Running total of principal
				
				# I = P * r * t
				interest_due += last_principal * (i - last_day) * (@apr / 365)

				# Set current iterations values as last_ for next transaction
				last_day = i > 1 ? i : 0 # edge case (Day 1 is mathematically day 0)
				last_amount = transaction
				last_principal = principal				
			end
		end
		
		# Total amount due is final principal plus total interest
		return principal + interest_due.round(2)
	end

end