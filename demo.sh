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

dfx deploy --argument='("Test Election", vec {"Yess"; "Noo"})'
echo "\n${GREEN}All canisters succesfully deployed${NC}\n"

echo "prova"