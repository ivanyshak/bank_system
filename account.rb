class Account

  attr_reader   :name, :psw
  attr_accessor :balance

  def initialize(name, psw, balance)
    @name = name
    @psw = psw
    @balance = balance
  end

end