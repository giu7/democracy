import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import ElectionActorClass "../election/election";
import Cycles "mo:base/ExperimentalCycles";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import Iter "mo:base/Iter";

actor Democracy {
  
  var elections = HashMap.HashMap<Principal, ElectionActorClass.Election>(1, Principal.equal, Principal.hash);
  var owners = HashMap.HashMap<Principal, List.List<Principal>>(1, Principal.equal, Principal.hash);

  public shared (msg) func createNewElection(name: Text) : async Principal {
    let caller = msg.caller;
    Debug.print(debug_show(caller));


    Debug.print(debug_show(Cycles.balance()));
    Cycles.add(200_500_000_000);
    //TODO remove hardcoded second parameter
    let newElection = await ElectionActorClass.Election(name, ["yes", "no"]);
    Debug.print(debug_show(Cycles.balance()));

    let newElectionPrincipal = await newElection.getPrincipal();
    
    elections.put(newElectionPrincipal, newElection);
    addOwnership(caller, newElectionPrincipal);

    return newElectionPrincipal;
  };

  public query func getOwnedElections(user: Principal) : async [Principal] {
    var ownedElections : List.List<Principal> = switch (owners.get(user)) {
      case null List.nil<Principal>();
      case (?result) result;
    };

    return List.toArray(ownedElections);
  };

  public query func getAllElections() : async [Principal] {
    return Iter.toArray(elections.keys());
  };

  private func addOwnership(owner: Principal, election: Principal) {
    var ownedElections : List.List<Principal> = switch (owners.get(owner)) {
      case null List.nil<Principal>();
      case (?result) result;
    };

    ownedElections := List.push(election, ownedElections);
    owners.put(owner, ownedElections);
  };

};
