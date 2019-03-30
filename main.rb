# Union Bank of Carlie - Banking App by Carlie Hamilton
# https://github.com/BlueCodeThree/Union-Bank-of-Carlie

# TODO
# make it so that it uses two decimal points
# error checking for input of monies
# way for user to cancel and go back to menu
# way to change pin
# history shows past 5 transactions, with an option to see the next five and previous five

require 'io/console' # dependency for the password
require 'yaml' # for saving my accounts hash

# here are some variables. The $ means they are "global" variables so I can use them in my methods
line = "-"
welcome = "| --  Welcome to the Union Bank of Carlie  -- |"
$like_to_do = "What would you like to do? (type: 'balance', 'deposit', 'withdraw', 'history' or 'exit')"

# load the accounts
$accounts = YAML.load_file('accounts.yml')

# The app begins... 
# Getting user and pin or creating a new account
puts line * welcome.length
puts welcome
puts line * welcome.length
puts "Please enter your name:"
$name = gets.chomp.capitalize
if $accounts.has_key? $name
    if $accounts[$name][:suspended] == true
        puts "Your account has been suspended"
        puts "Please contact your bank"
        abort
    else
        puts "Hi #{$name}! Please enter your pin:"
        guess_count = 0
        password_guess = IO::console.getpass
        while password_guess.to_i != $accounts[$name][:pin]
            guess_count += 1
            if guess_count < 3
                puts "Oops! Try again! Please type in your password"
                password_guess = IO::console.getpass
            else
                system('clear')
                puts "Your pin does not match"
                $accounts[$name][:suspended] = true
                File.write('accounts.yml', $accounts.to_yaml)
                puts "Your account has been suspended"
                puts "Please contact your bank"
                abort
            end
        end
    end
else 
    $accounts[$name] = {}
    puts "please create a pin:"
    password_save1 =  IO::console.getpass
    puts "please type your pin again:"
    password_save2 =  IO::console.getpass
    while password_save1 != password_save2
        system('clear')
        puts "Oops! Your passwords did not match. Please try again!"
        puts "please create a pin:"
        password_save1 =  IO::console.getpass
        puts "please type your pin again:"
        password_save2 =  IO::console.getpass
    end
    $accounts[$name] = {pin: password_save1.to_i, balance: 0, suspended: false, history: ["#{Time.now} - Account Opened, Balance: $0"]}
    File.write('accounts.yml', $accounts.to_yaml)
    
end

puts " "
puts "Welcome #{$name}!" 

# This method is for the initial user input for what they would like to do (display balance, deposit etc)
def banking_stuff
    puts " "
    puts $like_to_do
    $user_input = gets.chomp
    banking_loop
end

# for withdrawing monies
def withdraw_money(withdraw_local)
    $accounts[$name][:balance] = $accounts[$name][:balance] - withdraw_local
    $accounts[$name][:history] << "#{Time.now} - Withdraw: $#{withdraw_local}, Balance: $#{$accounts[$name][:balance]}"
    File.write('accounts.yml', $accounts.to_yaml)
    puts "Your balance is now $#{$accounts[$name][:balance]}"
    banking_stuff
end

# This is my loops for checking the balance, etc. Once something has been selected, it goes back to the start by calling a method again. 
def banking_loop
    system('clear')
    case $user_input
    when "b","balance"
        puts "Your balance is $#{$accounts[$name][:balance]}" 
        banking_stuff
    when "d","deposit"
        puts "How much would you like to deposit?"
        deposit = gets.chomp.to_i
        $accounts[$name][:balance] = $accounts[$name][:balance] + deposit
        $accounts[$name][:history] << "#{Time.now} - Deposit: $#{deposit}, Balance: $#{$accounts[$name][:balance]}"
        File.write('accounts.yml', $accounts.to_yaml)
        puts "Your balance is now $#{$accounts[$name][:balance]}"
        banking_stuff
    when "w","withdraw"
        puts "Your balance is $#{$accounts[$name][:balance]}"
        puts "How much would you like to withdraw?"
        withdraw = gets.chomp.to_i
        if withdraw > $accounts[$name][:balance]
            while true
                puts "Ooops, you don't have that much. Please try again!"
                puts "How much would you like to withdraw?"
                withdraw = gets.chomp.to_i
                if withdraw <= $accounts[$name][:balance]
                    withdraw_money(withdraw)
                end
            end
        else
            withdraw_money(withdraw)
        end
    when "h","history"
        puts "Transaction history for #{$name}:"
        puts $accounts[$name][:history]
        banking_stuff
    when "exit"
        abort("Goodbye #{$name}!")
    else
        while true
            puts "Sorry, something happened. Please try again"
            puts $like_to_do
            $user_input = gets.chomp
            case $user_input
            when "balance", 'b', "deposit", 'd', "exit", 'w', "withdraw", "history", "h"
                banking_loop
            end
        end
    end
end

## run the banking stuff loop!
while true
    banking_stuff
end




