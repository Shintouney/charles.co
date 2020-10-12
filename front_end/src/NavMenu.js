import React, { useState } from 'react';
import './App.css';
import DateTimePicker from 'react-datetime-picker'

function NavMenu() {
  const [value, onChange] = useState(new Date());
  const [value2, onChange2] = useState(new Date());

  return (
      <div class="col-lg-3">
        <h1 class="my-4">Shop Name</h1>
        <div class="list-group">
        <p>
          Date de début
        </p>
        <DateTimePicker
          onChange={onChange}
          value={value}
        />
        <p>
          Date de Fin
        </p>
        <DateTimePicker
          onChange={onChange2}
          value={value2}
        />
        </div>
      </div>
);
}

export default NavMenu;
