import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import Navbar from './Navbar';
import NavMenu from './NavMenu';
import NavBody from './NavBody';
import * as serviceWorker from './serviceWorker';
import 'bootstrap/dist/css/bootstrap.min.css';
import $ from 'jquery';
import Popper from 'popper.js';
import DateTimePicker from 'react-datetime-picker'
import 'bootstrap/dist/js/bootstrap.bundle.min';

ReactDOM.render(
  <React.StrictMode>
    <Navbar />
    <div class="container">
      <div class="row">
      <NavMenu />
      <NavBody />
      </div>
    </div>
  </React.StrictMode>,
  document.getElementById('root')
);


// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
