import * as React from "react";
import { render } from "react-dom";
import { democracy_backend } from "../../declarations/democracy_backend";
import {useEffect} from "react";

const Democracy = () => {
  const [name, setName] = React.useState('');
  const [message, setMessage] = React.useState('');
  const [elections, setElections] = React.useState([]);

  async function getAllElections() {
    const electionsArray = await democracy_backend.getAllElections();
    setElections(electionsArray);
    console.log('all elections: ');
    console.log(electionsArray);
  }

  useEffect(() => {
    console.log("useEffect is triggered")
    getAllElections();
  },[]);

  return (
    <div style={{ "fontSize": "30px" }}>
        <div className="h1" style={{ textAlign: "center" }}>D-emocracy</div>
        <br/>

        <fieldset>
          <legend>Election list</legend>
          {elections.map((electionItem) => {
            console.log(electionItem);
            <li>electionItem.toText()</li>
            })
          }
        </fieldset>
        <br/>

        <div style={{ margin: "30px", textAlign: "center" }}>
          <input
            id="electionName"
            value={name}
            placeholder="election name"
            style={{ margin: "30px", }}
          ></input>
          <button>Create new election</button>
        </div>

    </div>
  );
};

render(<Democracy />, document.getElementById("app"));
