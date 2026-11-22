// React and useRef were imported but never used
// import React, { useState, useEffect, useRef } from "react";
import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { login } from "./../services/userApi";
import Cookies from "universal-cookie";

// CHANGED: renamed the component to PascalCase.
// BEFORE: function logIn() {
// React components must start with an uppercase letter. With a lowercase name the
// rules-of-hooks lint doesn't treat it as a component and flags every hook call.
// It only worked because App.jsx imports it as `Login`.
function Login() {
  const navigate = useNavigate();
  // ADDON
  const [isAddonVisible, setIsAddonVisible] = useState(false);
  const [isUserValidError, setIsUserValidError] = useState(false);
  // CHANGED: new state to show a message when the backend can't be reached.
  // BEFORE: it didn't exist; a network error was never shown to the user.
  const [isServerError, setIsServerError] = useState(false);
  // ADVISES FOR INPUTS
  // ERROR: typo in the names ("Inser" -> "Insert").
  const [inputInserMailAdvise, setInputInserMailAdvise] = useState(false);
  const [inputInserPasswordAdvise, setInputInserPasswordAdvise] =
    useState(false);

  // ERROR: if a `token` cookie exists, it redirects to /home without asking the
  // backend. The cookie is just the user ID, never expires and is never validated,
  // so creating it by hand (`document.cookie = "token=1"`) is enough to get in.
  // This is why "logging in" works even when the backend is down.
  // SOLUTION: real authentication (JWT / session) and validate it against the
  // backend (e.g. a `/me` endpoint) before redirecting.
  // ERROR: `navigate` is missing from the dependency array (react-hooks/exhaustive-deps).
  useEffect(() => {
    const cookies = new Cookies();
    const token = cookies.get("token");

    if (token) {
      navigate("/home");
    }
  }, []);

  const userLogIn = async (event) => {
    event.preventDefault();
    const email = event.target.email.value;
    const pssd = event.target.pssd.value;
    const emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    // ERROR: `works` is useless; it's always true when checked in the last `else if`.
    // SOLUTION: remove it and use a plain `else`.
    let works = true;
    // ERROR: logs the password to the browser console.
    // SOLUTION: never log credentials.
    console.log(email, pssd);

    // CHANGED: reset both advises before validating.
    // BEFORE: they were never reset, so once shown they stayed visible even after
    // filling the fields correctly.
    setInputInserMailAdvise(false);
    setInputInserPasswordAdvise(false);

    // ERROR: hand-made validation with one state per message.
    // SOLUTION: `required` + `type="email"` on the inputs, or a form library + Zod.
    if (email === "" || pssd === "") {
      setInputInserMailAdvise(true);
      setInputInserPasswordAdvise(true);
      works = false;
    } else if (emailReg.test(email) === false) {
      // CHANGED: show the email advise.
      // BEFORE: setInputInserPasswordAdvise(false);
      // It only hid the password advise and never showed the email one, so an
      // invalid email did nothing at all.
      setInputInserMailAdvise(true);
      works = false;
    } else if (works === true) {
      // CHANGED: wrapped the request in try/catch.
      // BEFORE: const response = await login(email, pssd);
      // login() rethrows network errors, so with the backend down the promise was
      // rejected without being handled ("Uncaught (in promise) TypeError: Failed to
      // fetch") and the user saw nothing.
      let response;
      try {
        response = await login(email, pssd);
      } catch (error) {
        setIsAddonVisible(true);
        setIsServerError(true);
        return;
      }

      if (response && response.id) {
        const cookies = new Cookies();
        // ERROR: the "token" is just the user ID and the role is stored in an
        // editable cookie: changing `userRole` gives access to the admin panel.
        // SOLUTION: a signed JWT (httpOnly cookie) with the role inside, checked
        // by the backend on every request.
        cookies.set("token", response.id, { path: "/" });
        cookies.set("userRole", response.urole, { path: "/" });
        navigate("/home");
      } else {
        setIsAddonVisible(true);
        setIsUserValidError(true);
      }
    }
  };

  return (
    <>
      <div
        className="allCont backgroundGradient flex justify-center align-center flex-column"
        style={{ paddingBottom: "0px" }}
      >
        <div
          className="addonSet align-center"
          style={{
            display: isAddonVisible ? "flex" : "none",
          }}
        >
          <div
            id="showUserError"
            className="cage90 backgroundWhite marginAuto addonSetContainer"
            style={{ display: isUserValidError ? "block" : "none" }}
          >
            <h2>EL MAIL Y LA CONTRASEÑA NO COINCIDEN</h2>
            <button
              onClick={() => {
                setIsAddonVisible(false);
                setIsUserValidError(false);
              }}
            >
              OK
            </button>
          </div>
          {/* CHANGED: new popup for when the backend can't be reached. */}
          {/* BEFORE: it didn't exist. */}
          <div
            id="showServerError"
            className="cage90 backgroundWhite marginAuto addonSetContainer"
            style={{ display: isServerError ? "block" : "none" }}
          >
            <h2>NO SE HA PODIDO CONECTAR CON EL SERVIDOR</h2>
            <button
              onClick={() => {
                setIsAddonVisible(false);
                setIsServerError(false);
              }}
            >
              OK
            </button>
          </div>
        </div>
        <div className="cage80 loginOnDeskop" id="contLogin">
          <div className="loginLogo">
            <img src="logo.png" alt="gymlogs" />
            <h1>GYMLOGS</h1>
          </div>
          <div className="loginForm">
            <form action="" onSubmit={userLogIn}>
              <p
                className="adviseFormText cage90 block marginAuto"
                style={{
                  // CHANGED: removed the duplicated condition.
                  // BEFORE: inputInserMailAdvise || inputInserMailAdvise
                  display: inputInserMailAdvise ? "flex" : "none",
                }}
              >
                Inserta un correo electronico valido*
              </p>
              <input type="text" placeholder="Correo Electronico:" id="email" />
              <p
                className="adviseFormText cage90 block marginAuto"
                style={{
                  // CHANGED: removed the duplicated condition.
                  // BEFORE: inputInserPasswordAdvise || inputInserPasswordAdvise
                  display: inputInserPasswordAdvise ? "flex" : "none",
                }}
              >
                Inserta una contraseña*
              </p>
              <input type="password" placeholder="Contraseña:" id="pssd" />
              <input type="submit" className="button1" value="INICIAR SESION" />
              {/* <a href="">Has olvidado tu contraseña?</a> */}
            </form>
            {/* ERROR: a <button> inside an <a> is invalid HTML, and <a href> reloads the whole page. */}
            {/* SOLUTION: <Link to="/register" className="button2">REGISTRARSE</Link> from react-router-dom. */}
            <a href="/register">
              <button className="button2">REGISTRARSE</button>
            </a>
          </div>
        </div>
      </div>
    </>
  );
}

// CHANGED: BEFORE: export default logIn;
export default Login;
