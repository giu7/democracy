import * as React from "react";
import { render } from "react-dom";
import { democracy_backend } from "../../declarations/democracy_backend";
import {useEffect} from "react";
import Board from "./Board";

const Democracy = () => {
  const [electionName, setElectionName] = React.useState();
  const [elections, setElections] = React.useState();

  async function getAllElections() {
    const electionsArray = await democracy_backend.getAllElections();
    console.log('all elections: ');
    console.log(electionsArray);
    setElections(
      <Board title="Board" ids={electionsArray} />
    );
  }

  function createElection(e){
    e.preventDefault()
    democracy_backend.createNewElection(electionName);
  }

  function handleChange(e){
    const { value } = e.target;
    setElectionName(value);
  }

  useEffect(() => {
    console.log("[index] useEffect is triggered")
    getAllElections();
  },[]);

  return (
    <div style={{ "fontSize": "30px" }}>
        <div className="h1" style={{ textAlign: "center" }}>D-emocracy</div>
        <br/>

        {elections}
        <br/>

        <form onSubmit={createElection}>
          <div style={{ margin: "30px", textAlign: "center" }}>
            <input
              id="electionName"
              name="electionName"
              onChange={handleChange}
              placeholder="election name"
              style={{ margin: "30px", }}
            ></input>
            <button type="submit">Create new election</button>
          </div>
        </form>

    </div>
  );
};

render(<Democracy />, document.getElementById("app"));
