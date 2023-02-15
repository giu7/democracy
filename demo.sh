GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
PURPLE=$'\e[0;35m'
NC=$'\e[0m'

dfx stop
set -e
trap 'dfx stop' EXIT

echo "\n${PURPLE}dfx start --background --clean${NC}"
dfx start --background --clean

echo "\n${PURPLE}dfx identity new alice --disable-encryption || true${NC}"
dfx identity new alice --disable-encryption || true
ALICE=$(dfx --identity alice identity get-principal)
echo "${GREEN}Created Identity for Alice. Principal:" $ALICE "${NC}\n"

echo "${PURPLE}dfx identity new bob --disable-encryption || true${NC}"
dfx identity new bob --disable-encryption || true
BOB=$(dfx --identity bob identity get-principal)
echo "${GREEN}Created Identity for Bob. Principal:" $BOB "${NC}\n"

echo "${PURPLE}dfx identity new charles --disable-encryption || true${NC}"
dfx identity new charles --disable-encryption || true
CHARLES=$(dfx --identity charles identity get-principal)
echo "${GREEN}Created Identity for Charles. Principal:" $CHARLES "${NC}\n"

echo "${PURPLE}dfx identity use default${NC}"
dfx identity use default
DEFAULT=$(dfx --identity default identity get-principal)
echo "${GREEN}Default Principal:" $DEFAULT "${NC}\n"

#dfx deploy --argument='("Test Election", vec {"Yess"; "Noo"})'
echo "${PURPLE}dfx deploy democracy_backend${NC}"
dfx deploy democracy_backend
echo "\n${GREEN}democracy_backend canister succesfully deployed${NC}\n"

echo "${PURPLE}dfx canister call democracy_backend getOwnedElections '(principal \"$DEFAULT\")'${NC}"
dfx canister call democracy_backend getOwnedElections '(principal "'$DEFAULT'")'
echo "${GREEN}Now dafault identity owns no elections${NC}\n"

echo "${GREEN}Creating a new election called DemoElection with default identity${NC}"
echo "${PURPLE}dfx canister call democracy_backend createNewElection '(\"DemoElection\")'${NC}"
ELECTION_PRINCIPAL=$(dfx canister call democracy_backend createNewElection '("DemoElection")')
ELECTION_PRINCIPAL=${ELECTION_PRINCIPAL/#"(principal \""} # remove prefix
ELECTION_PRINCIPAL=${ELECTION_PRINCIPAL/%"\")"} # remove suffix
echo "${GREEN}DemoElection Principal:" $ELECTION_PRINCIPAL "${NC}\n"

echo "${PURPLE}dfx canister call democracy_backend getOwnedElections '(principal \"$DEFAULT\")'${NC}"
dfx canister call democracy_backend getOwnedElections '(principal "'$DEFAULT'")'
echo "${GREEN}Now dafault identity owns one election (the DemoElection just created)${NC}\n"

echo "${PURPLE}dfx identity use alice${NC}"
dfx identity use alice
echo "\n${GREEN}Voting YES with Alice identity${NC}"
echo "${PURPLE}dfx canister call $ELECTION_PRINCIPAL vote '(\"Yes\")'${NC}"
dfx canister call $ELECTION_PRINCIPAL vote '("Yes")'

echo "\n${GREEN}Voting again YES with Alice identity. This vote will fail since Alice has already voted${NC}"
echo "${PURPLE}dfx canister call $ELECTION_PRINCIPAL vote '(\"Yes\")'${NC}"
dfx canister call $ELECTION_PRINCIPAL vote '("Yes")'

echo "\n${PURPLE}dfx identity use bob${NC}"
dfx identity use bob
echo "\n${GREEN}Voting No with Bob identity${NC}"
echo "${PURPLE}dfx canister call $ELECTION_PRINCIPAL vote '(\"No\")'${NC}"
dfx canister call $ELECTION_PRINCIPAL vote '("No")'

echo "\n${PURPLE}dfx identity use charles${NC}"
dfx identity use charles
echo "\n${GREEN}Voting Yes with Charles identity${NC}"
echo "${PURPLE}dfx canister call $ELECTION_PRINCIPAL vote '(\"Yes\")'${NC}"
dfx canister call $ELECTION_PRINCIPAL vote '("Yes")'

echo "\n${PURPLE}dfx canister call $ELECTION_PRINCIPAL getVoters${NC}"
VOTERS=$(dfx canister call $ELECTION_PRINCIPAL getVoters)
echo "${GREEN}Voters Principal: " $VOTERS "${NC}"

echo "\n${PURPLE}dfx canister call $ELECTION_PRINCIPAL getYes${NC}"
YES_COUNT=$(dfx canister call $ELECTION_PRINCIPAL getYes)
YES_COUNT=${YES_COUNT/#"("} # remove prefix
YES_COUNT=${YES_COUNT/%" : nat)"} # remove suffix
echo "${GREEN}Yes Votes: " $YES_COUNT "${NC}"

echo "\n${PURPLE}dfx canister call $ELECTION_PRINCIPAL getNo${NC}"
NO_COUNT=$(dfx canister call $ELECTION_PRINCIPAL getNo)
NO_COUNT=${NO_COUNT/#"("} # remove prefix
NO_COUNT=${NO_COUNT/%" : nat)"} # remove suffix
echo "${GREEN}No  Votes: " $NO_COUNT "${NC}"

echo "\n${GREEN}Yes Wins!${NC}\n"