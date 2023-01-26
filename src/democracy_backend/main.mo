import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import ElectionActorClass "../election/election";
import Cycles "mo:base/ExperimentalCycles";

actor Democracy {
  
  public shared (msg) func createNewElection(name: Text) : async Principal {
    let caller = msg.caller;

    Debug.print(debug_show(Cycles.balance()));
    Cycles.add(200_500_000_000);
    let newElection = await ElectionActorClass.Election(name);
    Debug.print(debug_show(Cycles.balance()));

    let newElectionPrincipal = await newElection.getPrincipal();

    return newElectionPrincipal;
  };

};
