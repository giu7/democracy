import Debug "mo:base/Debug"

actor class Election (_name: Text) {
    Debug.print("Election Works!");

    let name = _name;

    public query func getName() : async Text {
        return name;
    };
}