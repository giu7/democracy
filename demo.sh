GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

dfx stop
set -e
trap 'dfx stop' EXIT

dfx start --background --clean

dfx identity new alice --disable-encryption || true
ALICE=$(dfx --identity alice identity get-principal)
echo "\n${GREEN}Created Identity for Alice. Principal:" $ALICE "${NC}\n"

dfx identity new bob --disable-encryption || true
BOB=$(dfx --identity bob identity get-principal)
echo "\n${GREEN}Created Identity for Bob. Principal:" $BOB "${NC}\n"

dfx identity new charles --disable-encryption || true
CHARLES=$(dfx --identity charles identity get-principal)
echo "\n${GREEN}Created Identity for Charles. Principal:" $CHARLES "${NC}\n"

dfx identity use default

#dfx deploy --argument='("Test Election", vec {"Yess"; "Noo"})'
dfx deploy democracy_backend
echo "\n${GREEN}democracy_backend canister succesfully deployed${NC}\n"

echo "\n${GREEN}Creating a new election called DemoElection with default identity${NC}\n"
ELECTION_PRINCIPAL=$(dfx canister call democracy_backend createNewElection '("DemoElection")')
ELECTION_PRINCIPAL=${ELECTION_PRINCIPAL/#"(principal \""} # remove prefix
ELECTION_PRINCIPAL=${ELECTION_PRINCIPAL/%"\")"} # remove suffix
echo "\n${GREEN}Election Principal:" $ELECTION_PRINCIPAL "${NC}\n"

dfx identity use alice
echo "\n${GREEN}Voting YES with Alice identity${NC}\n"
dfx canister call $ELECTION_PRINCIPAL vote '("Yes")'

echo "\n${GREEN}Voting again YES with Alice identity. This vote will fail since Alice has already voted${NC}\n"
dfx canister call $ELECTION_PRINCIPAL vote '("Yes")'

dfx identity use bob
echo "\n${GREEN}Voting No with Bob identity${NC}\n"
dfx canister call $ELECTION_PRINCIPAL vote '("No")'

dfx identity use charles
echo "\n${GREEN}Voting Yes with Charles identity${NC}\n"
dfx canister call $ELECTION_PRINCIPAL vote '("Yes")'

YES_COUNT=$(dfx canister call $ELECTION_PRINCIPAL getYes)
YES_COUNT=${YES_COUNT/#"("} # remove prefix
YES_COUNT=${YES_COUNT/%" : nat)"} # remove suffix

NO_COUNT=$(dfx canister call $ELECTION_PRINCIPAL getNo)
NO_COUNT=${NO_COUNT/#"("} # remove prefix
NO_COUNT=${NO_COUNT/%" : nat)"} # remove suffix

echo "\n${GREEN}Yes Votes: " $YES_COUNT "${NC}"
echo "${GREEN}No  Votes: " $NO_COUNT "${NC}"

echo "\n${GREEN}Yes Wins!${NC}\n"