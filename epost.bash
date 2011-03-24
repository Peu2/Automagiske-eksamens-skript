#!/bin/bash 

## 
# Automatisert epost installasjon
# Rev. 0.1 (1.0 er det samme som fult operativ)
# -------------
# 0.1 Skjelettet opprettet. Ingen ting lagt til ennå. 
# Lagt til sjekk om det er nett på maskinen. Ingen grunn til å kjøre i gang
# installasjoner uten nett.
# Må få oversikt over nødvendige variabler til konfigurasjonen.
# -------------
# Last edit: Thu 24 Mar 2011
#
# TODO:
# 1. Skaff en oversikt over alle konfigurasjonsfilene som er nødvendig
# 2. Få på plass variabler som vi trenger til konfigurasjonsfilene
# 3. Legge til installasjon av postfix
# 4. Legge til installasjon av courier
# 5. Legge til installasjon av amavis med clamav til virus og spamassassin til spam
# 6. Legge til installasjon av postgrey og policy-weight
# 7. Finne ut om vi kan mate inn verdier i konfigdialoger under installasjon.
##

# Kommenter ut når rev er testet. 
if [ "$1" != "test" ]; then
	echo "Det jobbes med scriptet for øyeblikket vennligst prøv igjen senere"
	exit
fi

# Sikre at kun root kan kjøre skriptet.
if (( $UID != 0 )); then
	echo "*!* FATAL: Can only be executed by root."
	exit
fi

# Vi er avhengig av nett til installasjonene så vi gjør en pingtest


# Variablelkassen. Kom med innspill her på hvilke verdier som vi trenger.
HOSTNAVN="" # Denne MÅ vi ha
DOMENE=""   # Denne MÅ vi ha
HOSTIP=""   # Denne MÅ vi ha



#################################################
# UNDER DETTE SKILLET SKAL KUN FUNKSJONER LIGGE #
#################################################

# Rydde funksjon. Kun et skjelett må fylles
function cleanUp()
{

}

# Funksjon for kontroll av input. Må endres slik at den 
# passer inputen forventet til epost oppsettet. Hentet fra tihlde skript.
function getInput()
{
	if (( $1 == 1 )); then		## THIS MEANS ANY INPUT IS FINE !
		VERIFY_INPUT=0
	elif (( $1 == 2 )); then	## THIS MEANS YES/NO CONFIRMATION
		VERIFY_INPUT=1
	else
		VERIFY_INPUT=2		## SELECTIVE INPUT
	fi

	loop=0
	while (($loop != 1)); do

		echo -n "< $QUESTION"
		INPUT=""
		read INPUT

		# make a copy of the input in lower case
		INPUT_LOWER_CASE=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')

		# *always* exit if we get 'q'
		if [ "$INPUT_LOWER_CASE" == "q" ]; then
			cleanUp
			exit
		fi

		# we don't want input that's empty unless it's for mode 1
		if (( $VERIFY_INPUT != 0 )) && (( ${#INPUT} == 0 )); then
			continue
		fi

		# if we're in mode 1 (verify == 0) we basicly just accept any input. 
		# in this case we set loop=1 so the while exits
		if (( $VERIFY_INPUT == 0 )); then
			loop=1
		elif (( $VERIFY_INPUT == 1 )); then
			if [ "$INPUT_LOWER_CASE" == "y" ] || [ "$INPUT_LOWER_CASE" == "n" ]; then
				loop=1
			fi
		else
			## remember; $1 is input option, start at 2nd argument
			for ((x=2; x!=$(($#+1)); x++)); do

				if [ "$INPUT" == "${@:$x:1}" ]; then
					loop=1
				fi
			done
		fi
	done
}


