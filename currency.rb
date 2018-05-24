class Currency

  def self.banknotes_sum
    $config['banknotes'].sum{|k, v| k.to_s.to_i * v}
  end

end