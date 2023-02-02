import * as React from "react";
import { render } from "react-dom";
import { democracy_backend } from "../../declarations/democracy_backend";

const Democracy = () => {
  const [name, setName] = React.useState('');
  const [message, setMessage] = React.useState('');

  async function getAllElections() {
    const elections = await democracy_backend.getAllElections();
    console.log('all elections: ');
    console.log(elections);
  }

  return (
    <div style={{ "fontSize": "30px" }}>
      <div style={{ "backgroundColor": "yellow" }}>
        <p>React Example Page!</p>
        <p>
          {" "}
          Click{" "}
          <b> Get All Elections!</b> to have the list of elections. I don't know how to extract Principals from that list
        </p>
      </div>
      <div style={{ margin: "30px" }}>
        <input
          id="name"
          value={name}
          onChange={(ev) => setName(ev.target.value)}
        ></input>
        <button onClick={getAllElections}>Get All Elections!</button>
      </div>
      <div>
        Elections are: (NOT WORKING) "
        <span style={{ color: "blue" }}>{message}</span>"
      </div>
    </div>
  );
};

render(<Democracy />, document.getElementById("app"));
