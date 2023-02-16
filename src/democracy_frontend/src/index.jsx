import * as React from "react";
import { render } from "react-dom";
import { democracy_backend } from "../../declarations/democracy_backend";
import {useEffect, useState} from "react";
import LoadingButton from '@mui/lab/LoadingButton';
import {Container, Grid, Paper, Stack, TextField, Typography} from "@mui/material";
import SaveIcon from '@mui/icons-material/Save';
import DashboardIcon from "@mui/icons-material/Dashboard";
import Item from "./Item";

const Democracy = () => {
  const [electionName, setElectionName] = React.useState();
  const [items, setItems] = useState();

  const [loading, setLoading] = React.useState(false);

  async function getAllElections() {
    let electionsArray = await democracy_backend.getAllElections();
    console.log('all elections: ');
    console.log(electionsArray);

    setItems(
      electionsArray.map((ElectionId) => (
        <Item id={ElectionId} key={ElectionId.toText()} />
      ))
    );
  }

  async function createElection(e){
    e.preventDefault()

    setLoading(true);
    await democracy_backend.createNewElection(electionName);
    setLoading(false);

    getAllElections();
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

      <Stack direction="row" spacing={2}>
        <DashboardIcon/>
        <Typography variant="h5" component="div">
          Board
        </Typography>
      </Stack>

      <Grid container spacing={2}>
        {items}
      </Grid>

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
            <LoadingButton loading={loading} loadingPosition="start" startIcon={<SaveIcon />}
                           variant="contained" type="submit"> <span>Create new election</span> </LoadingButton>
          </Paper>
        </div>
      </form>
    </Container>
  );
};

render(<Democracy />, document.getElementById("app"));
