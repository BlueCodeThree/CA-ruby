def account_suspended
    puts "Your account has been suspended"
    puts "Please contact your bank"
    abort
end

def create_pin
    puts "please create a pin:"
    password_save1 =  IO::console.getpass
    puts "please type your pin again:"
    password_save2 =  IO::console.getpass
end

# for withdrawing monies
def withdraw_money(withdraw_local)
    $accounts[$name][:balance] = $accounts[$name][:balance] - withdraw_local
    $accounts[$name][:history] << "#{Time.now} - Withdraw: $#{withdraw_local}, Balance: $#{$accounts[$name][:balance]}"
    File.write('accounts.yml', $accounts.to_yaml)
    puts "Your balance is now $#{$accounts[$name][:balance]}"
    banking_stuff
end