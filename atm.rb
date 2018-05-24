require_relative 'account'
require_relative 'currency'
require 'yaml'

$config = YAML.load_file(ARGV.first || 'config.yml')

class AtmBank

  def appname
    "Bank ATM"
  end

  def divider
    "\n--------------------"
  end

  def welcome
    puts "\nWelcome to #{appname}.#{divider}"
    log_in
  end


  def log_in
    puts "\nPlease Enter Your Account Number:"
    account_number = gets.chomp.to_i
    puts 'Please Enter Your Password'
    @password = gets.chomp.to_s
    client = $config['accounts'].detect do |key, value|
      if key == account_number
        @client = Account.new(value['name'], value['password'], value['balance'])
        check_client
      end
      check_client
    end
  end

  def check_client
    if @client
      if @client.psw == @password
        puts "Hello, #{@client.name}"
        self.get_choice(@client)
      else
        puts 'Wrong account password'
      end
    else
      puts 'Wrong account number'
    end
    welcome
  end

  def get_choice(client)
    @choose = 0
    while @choose != 3 do
      puts "Please Choose From the Following Options:\n 1. Display Balance\n 2. Withdraw\n 3. Log Out"

      @choose = gets.chomp.to_i
      case @choose
      when 1
        puts "You Current Balance is, #{@client.balance}"
      when 2
        @total = Currency.banknotes_sum
        @ammount = @total + 1
        while @ammount > @total do
          puts "Enter Amount You Wish to Withdraw:"
          @ammount = gets.chomp.to_i
          begin
            if @ammount > @client.balance
              raise IOError.new("ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:")
            elsif @ammount > @total
              raise IOError.new("ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS ₴#{@total}. PLEASE ENTER A DIFFERENT AMOUNT:")
            else
              @client.balance -= @ammount
              puts "Your New Balance is #{@client.balance}"
            end
          rescue IOError => e
            puts e.message
          end
        end
      when 3
        puts "#{client.name}, Thank You For Using Our ATM. Good-Bye!"
      end
    end
  end

    atm = AtmBank.new()
    atm.welcome

end