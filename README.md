# D-emocracy

Welcome to the first prototype of D-emocracy, the first large-scale voting platform on Internet Computer.

If this is the first time you run this project, mske sure to start running
```bash
npm install
```
Then you can start local dfx environment with
```bash
dfx start --clean
```

To deploy all the canisters, passing argument for Election use
```bash
dfx deploy --argument='("Test Election", vec {"Yess"; "Noo"})'
```

Once the job completes, your application will be available at `http://localhost:4943?canisterId={asset_canister_id}`.

To create a new election via command line
```bash
dfx canister call democracy_backend createNewElection '("prova")'
```

To vote for the test election via command line
```bash
dfx canister call election vote '("yes")'
```

You can get your principal running
```bash
dfx identity get-principal
```

Additionally, if you are making frontend changes, you can start a development server with

```bash
npm start
```

Which will start a server at `http://localhost:8080`, proxying API requests to the replica at port 4943.