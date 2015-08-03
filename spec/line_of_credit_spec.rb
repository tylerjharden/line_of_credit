require "./line_of_credit"

describe LineOfCredit do
  
	# Setup LineOfCredit for each test
	before :each do
		@loc = LineOfCredit.new 1000.00, 0.35 # Credit Limit, APR %
	end
	
	describe "#new" do
		it "takes two parameters and returns a LineOfCredit object" do
			@loc.should be_an_instance_of LineOfCredit
		end
	end
	
	describe "#limit" do
		it "returns the correct credit limit" do
			@loc.limit.should eql 1000.00
		end
	end
	
	describe "#apr" do
		it "returns the correct APR" do
			@loc.apr.should eql 0.35
		end
	end
	
	describe "#draw" do
		it "takes out the correct amount of money" do
			@loc.draw(100)
			@loc.principal.should eql 100
		end
	end
	
	describe "#scenario1" do
		it "returns a total payoff amount of $514.38 after 30 days of $500 principal" do
			@loc.draw(500,1)
			due = @loc.calculate_total_due()
			due.should eql 514.38
		end
	end
	
	describe "#scenario2" do
		it "returns a total payoff amount of $411.99 after 15 days of $500, plus $300 for 10 days, and $400 for 5 days" do
			@loc.draw(500,1)
			@loc.make_payment(200,15)
			@loc.draw(100,25)
			due = @loc.calculate_total_due()
			due.should eql 411.99
		end
	end
  
  end