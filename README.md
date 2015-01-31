# Foodstruck
Created at PennApps Winter 2015 by Joe Cappadona, Alice Ren, and Archit Sharma.

As college students in Philadelphia, we often purchase our breakfasts and lunches from food trucks all over University City. They cook our favorite sandwiches and their prices can't be beat; however, waking up even 10 minutes before class is a hassle, and nobody wants to leave the warm library and walk a quarter-mile just to grab lunch. That's where Foodstruck comes in.

Whether you want to order a meal the night in advance to pick up on your way to class or if you want somebody to bring your favorite food truck dish right to your dorm, Foodstruck supports it.

## Technology

Foodstruck retrieves food truck locations and menus from a Firebase database, displaying the food trucks nearest you in both a map and a list view. If you choose to pick up your order, Foodstruck uses Twilio to send a text message containing your order and pick-up time to the truck owner. If you'd rather have the food come to you, Foodstruck implements the Postmates API to offer a delivery fee quote, then shows the courier's progress in real-time until it is delivered.

## Next steps

This app was intended to have a counterpart for owners of food trucks that would allow creation and editing of menus, one-tap geolocating (thus updating the truck's location on the map for customers to see), reception of orders, and eventually, the ability to accept payment electronically and track sales through the app over time. We ran out of time to implement this, but we hope to make it a reality in the near future.
