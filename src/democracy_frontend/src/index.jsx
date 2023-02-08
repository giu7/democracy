import * as React from "react";
import { render } from "react-dom";
import { democracy_backend } from "../../declarations/democracy_backend";
import {useEffect} from "react";
import Board from "./Board";
import Button from "@mui/material/Button"
import {Container, Paper, TextField, Typography} from "@mui/material";

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
    <Container fixed>
      <Typography variant="h2" component="div" align="center"
                  style={{
                    background: "-webkit-linear-gradient(45deg, #2196F3 30%, #21F364 90%)",
                    webkitBackgroundClip: "text",
                    WebkitTextFillColor: "transparent",
                  }}>
        D•emocracy
      </Typography>

      {elections}

      <form onSubmit={createElection}>
        <div style={{ margin: "30px", textAlign: "center" }}>
          <TextField
            id="electionName"
            name="electionName"
            onChange={handleChange}
            label="election name"
            variant="outlined"
          />

          <Paper elevation={3} >
            <Button variant="contained" type="submit">Create new election</Button>
          </Paper>
        </div>
      </form>
    </Container>
  );
};

render(<Democracy />, document.getElementById("app"));
