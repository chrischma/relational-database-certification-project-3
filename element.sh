#!/bin/bash
PSQL="psql --username=postgres --dbname=periodic_table -t -c"

if [[ -z $1 ]]; then
  echo 'Please provide an element as an argument.'
  exit 0
fi


SELECT_BY_NAME=$($PSQL "
SELECT * 
FROM elements 
WHERE name = '$1'
")

IFS=' | ' read -r atomic_number symbol name <<< $SELECT_BY_NAME



if [[ $name == "" ]]; then
SELECT_BY_SYMBOL=$($PSQL "
SELECT * 
FROM elements 
WHERE symbol = '$1'
")


IFS=' | ' read -r atomic_number symbol name <<< $SELECT_BY_SYMBOL
fi


if [[ $name == "" ]]; then
SELECT_BY_ATOMIC_NUMBER=$($PSQL "
SELECT * 
FROM elements 
WHERE atomic_number = '$1'
")

IFS=' | ' read -r atomic_number symbol name <<< $SELECT_BY_ATOMIC_NUMBER
fi

SELECT_PROPERTIES=$($PSQL "
SELECT * 
FROM properties 
WHERE atomic_number = '$atomic_number'
")
IFS=' | ' read -r atomic_number atomic_mass melting_point_celsius boiling_point_celsius type_id <<< $SELECT_PROPERTIES

type=$($PSQL "
SELECT type 
FROM types 
WHERE type_id = '$type_id'
")


if [[ $name == "" ]]; then
echo "I could not find that element in the database."
exit 0
fi

echo "The element with atomic number "$atomic_number "is "$name" ("$symbol"). It's a"$type", with a mass of "$atomic_mass" amu. "$name" has a melting point of "$melting_point_celsius" celsius and a boiling point of "$boiling_point_celsius" celsius."
