import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import './App.css';
import logo from 'images/logo.svg';
require("@rails/ujs").start()

var deferredPrompt; 

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      installed: false
    }
  };

  isInStandaloneMode = () => ('standalone' in window.navigator) && (window.navigator.standalone);

  isIos = () => {
    const userAgent = window.navigator.userAgent.toLowerCase();
    return /iphone|ipad|ipod/.test( userAgent );
  }

  componentDidMount() {
    if (window.matchMedia('(display-mode: standalone)').matches) { 
      this.setState({installed: true});
    }
   
    if (this.isIos() && this.isInStandaloneMode()) {
      this.setState({installed: true});
    }


    var self = this;
    window.addEventListener('beforeinstallprompt', function (e) { 
      deferredPrompt = e; 
      self.showAddToHomeScreen();
    }); 
  }

  showAddToHomeScreen() { 
    var a2hsBtn = document.querySelector(".ad2hs-prompt"); 
    a2hsBtn.style.display = "block"; 
    a2hsBtn.addEventListener("click", this.addToHomeScreen); 
  } 
  
  addToHomeScreen() { 
    var a2hsBtn = document.querySelector(".ad2hs-prompt"); 
    // hide our user interface that shows our A2HS button 
    a2hsBtn.style.display = 'none'; // Show the prompt 
    deferredPrompt.prompt(); // Wait for the user to respond to the prompt 
    deferredPrompt.userChoice.then(function(choiceResult){ 
      if (choiceResult.outcome === 'accepted') { 
        console.log('User accepted the A2HS prompt'); 
      } else { 
        console.log('User dismissed the A2HS prompt'); 
      } deferredPrompt = null; }); 
  } 

  render() {

    return (
      <div>
      { this.state.installed ? '' :
        <div className="box ad2hs-prompt">
          <div className="columns is-mobile">
            <div className="column" style={{display: 'flex', 'alignItems': 'center'}}>
              <img width="38" className="image" src={logo} />
            </div>
            <div className="column">
              <button className="ad2hs-prompt button is-primary"> Add to Home </button>
            </div>
          </div>
          <div className="columns" style={{display: 'flex', 'alignItems': 'center', 'textAlign': 'center'}}>
            <p> Add TornTrader App to your mobile device! </p>
          </div>
        </div> 
      }
      </div>
    )
  }
}

export default App;
