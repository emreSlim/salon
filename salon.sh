#! /bin/bash


query(){
  echo "$(psql --username=freecodecamp --dbname=salon --tuples-only -c "$1")"
}

menu(){
  query "select * from services" | while read sid bar sname
                                do 
                                  echo "$sid) $sname"
                                done
}

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?"

menu

read SERVICE_ID_SELECTED

sname=`query "select name from services where service_id=$SERVICE_ID_SELECTED" | sed -r 's/^ *| *$//'`
if [[ -z $sname ]]
then
  echo "I could not find that service. What would you like today?"
  menu
else
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=`query "select name from customers where phone='$CUSTOMER_PHONE'" | sed -r 's/^ *| *$//'`

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    cinsert=`query "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')"`
  fi
   cid=`query "select customer_id from customers where phone='$CUSTOMER_PHONE'" | sed -r 's/^ *| *$//'`
  echo "What time would you like your $sname, $CUSTOMER_NAME?"
  read SERVICE_TIME
  sinsert=`query "insert into appointments (customer_id,service_id,time) values($cid,$SERVICE_ID_SELECTED,'$SERVICE_TIME')"`
  echo "I have put you down for a $sname at $SERVICE_TIME, $CUSTOMER_NAME."
fi
