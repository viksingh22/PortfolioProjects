# Asking the user how much money is in their wallet
money = int(input("How much money do you have in your wallet?: "))
# Making a dictionary of fruits and their prices
items = {'apple': 1.5, 'banana': .5, 'orange': .75}
# This loop asks the quantity of fruits the user wants to buy and runs the calculations then checks the balance against the wallet balance using if statements to decide what to do next
for item_name in items:
  # Adding a separator line for displaying each fruit section cleanly
  print("......................................................")
  # Telling the user how much is in their wallet
  print("You have " + str(money) + " dollars in your wallet")
  # Going through the dictionary letting the user know how much the fruit costs
  print("Each " + item_name + " costs " + str(items[item_name]) + " dollars")
  # Asking the user how much quantity they want
  input_count = input("How many " + item_name + "s do you want?: ")
  # Telling the user what they are trying to buy
  print("You will buy " + input_count + " " + item_name + "s")
  # Calculating the price for that item based on the quantity the user selected
  total_price = int(input_count) * items[item_name]
  print("The total price is " + str(total_price) + " dollars")
  # Checking the cost against their wallet using if statements to decide what to do next
  if money >= total_price:
    print("You have bought " + input_count + " " + item_name + "s")
    money -= total_price
    if money == 0:
      print("Your wallet is empty")
      break
  else:
    print("You don't have enough money")
    print("You can't buy that many " + item_name + "s")
print("You have " + str(money) + " dollars left")
