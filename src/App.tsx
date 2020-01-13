import React, { useState, useEffect } from "react";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import "./App.css";

const App: React.FC = () => {
	return (
		<div className="app">
			<BrowserRouter>
				<Switch>
					<Route
						path="/"
						render={props => <HelloWorld {...props} name={"Yanks"} />}
					/>
				</Switch>
			</BrowserRouter>
		</div>
	);
};

interface HelloWorld {
	name: string;
	age?: number;
}

export const HelloWorld = (world: HelloWorld) => {
	return (
		<div>
			{world.name}
			{world.age}
			<StatefulHello name="Rachel" />
		</div>
	);
};

interface StatefulHello {
	name: string;
	ttl?: number;
asdfa
}

export const StatefulHello = ({ name, ttl = 3 }: StatefulHello) => {
	const [currentName, setCurrentName] = useState(name);
	useEffect(() => {
		setTimeout(() => {
			setCurrentName("Marvel");
		}, ttl * 1000);
	}, [ttl]);
	return <div>{currentName}</div>;
};

export default App;
