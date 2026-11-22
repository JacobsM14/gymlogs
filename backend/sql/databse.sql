-- DROP TABLE calendar;
-- DROP TABLE sessio_exercise;
-- DROP TABLE sessions;
-- DROP TABLE exercise;
-- DROP TABLE type_exercise;
-- DROP TABLE category;
-- DROP TABLE routines;
-- DROP TABLE users;

-- DROP DATABASE prova;

-- CREATE DATABASE prova;

-- USE prova;

-- THIS SHOULDN'T EXIST, IT SHOULD BE AN ORM
CREATE TABLE type_exercise(
	pk_id_type INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE category(
	pk_id_category INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(200) NOT NULL
);

CREATE TABLE exercise(
	pk_id_exercise INT PRIMARY KEY AUTO_INCREMENT,
	exercise_name VARCHAR(200) NOT NULL,
	link_video VARCHAR(400),
	description VARCHAR(500),
	fk_category_1 INT,
	fk_category_2 INT,
	fk_id_type INT NOT NULL,
	FOREIGN KEY (fk_category_1) REFERENCES category(pk_id_category),
	FOREIGN KEY (fk_category_2) REFERENCES category(pk_id_category),
	FOREIGN KEY (fk_id_type) REFERENCES type_exercise(pk_id_type)
);

CREATE TABLE users(
	pk_id_user INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(400) NOT NULL,
	email VARCHAR(400) NOT NULL,
	pssd VARCHAR(250) NOT NULL,
	urole INT NOT NULL,
	foto LONGBLOB
);

CREATE TABLE routines(
	pk_id_routine INT PRIMARY KEY AUTO_INCREMENT,
	routine_name VARCHAR(100) NOT NULL,
	type_routine VARCHAR(100) NOT NULL ,
	day_routine VARCHAR(300),
	num_routine INT,
	fk_id_username INT NOT NULL,
	CHECK (type_routine = "libre" OR type_routine = "semanal"),
	FOREIGN KEY (fk_id_username) REFERENCES users(pk_id_user) ON DELETE CASCADE
);

CREATE TABLE mainRoutine(
	pk_id_mainroutine INT PRIMARY KEY AUTO_INCREMENT,
	fk_id_user INT NOT NULL,
	fk_id_routine INT NOT NULL,
	FOREIGN KEY (fk_id_user) REFERENCES users(pk_id_user) ON DELETE CASCADE,
	FOREIGN KEY (fk_id_routine) REFERENCES routines(pk_id_routine) ON DELETE CASCADE
);	

CREATE TABLE sessions(
	pk_id_sessio INT PRIMARY KEY AUTO_INCREMENT,
	nom_session VARCHAR(200) NOT NULL,
	week_day VARCHAR(300),
	fk_category_1 INT,
	fk_category_2 INT,
	fk_id_routine INT NOT NULL,
	FOREIGN KEY (fk_category_1) REFERENCES category(pk_id_category),
	FOREIGN KEY (fk_category_2) REFERENCES category(pk_id_category),
	FOREIGN KEY (fk_id_routine) REFERENCES routines(pk_id_routine) ON DELETE CASCADE
);

CREATE TABLE sessions_exercise(
	pk_id_sessio_ex INT PRIMARY KEY AUTO_INCREMENT,
	fk_id_sessio INT NOT NULL,
	fk_id_exercise INT NOT NULL,
	FOREIGN KEY (fk_id_sessio) REFERENCES sessions(pk_id_sessio) ON DELETE CASCADE,
	FOREIGN KEY (fk_id_exercise) REFERENCES exercise(pk_id_exercise) ON DELETE CASCADE 
);

CREATE TABLE calendar(
	pk_id_calendar INT PRIMARY KEY AUTO_INCREMENT,
	serie INT NOT NULL,
	weight INT NOT NULL,
	repetitions INT, 
	duration VARCHAR(100),
	day DATE NOT NULL,
	fk_id_session_ex INT NOT NULL,
	FOREIGN KEY (fk_id_session_ex) REFERENCES sessions_exercise(pk_id_sessio_ex) ON DELETE CASCADE
);	

INSERT INTO type_exercise (name) VALUES ("Peso Libre"), ("Calistenia"), ("Cardio"), ("Maquina");

INSERT INTO category (name) VALUES ("Pecho"), ("Brazos"), ("Espalda"), ("Piernas");

-- Insert exercises for "Peso Libre" type and "Pecho" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Press de Banca', 'youtube.com', 'Acuéstate en un banco plano, agarra la barra con las manos a una distancia ligeramente mayor que el ancho de los hombros, baja la barra hasta que toque el pecho y luego empuja hacia arriba.', 1, 1),
    ('Press Inclinado', 'youtube.com', 'Acuéstate en un banco inclinado, agarra la barra con las manos a una distancia ligeramente mayor que el ancho de los hombros, baja la barra hasta que toque el pecho y luego empuja hacia arriba.', 1, 1),
    ('Aperturas con Mancuernas', 'youtube.com', 'De pie, sostén una mancuerna en cada mano frente a ti con los brazos extendidos. Abre los brazos hacia los lados hasta que sientas un estiramiento en el pecho, luego vuelve a la posición inicial.', 1, 1),
    ('Flexiones', 'youtube.com', 'Colócate en posición de plancha con las manos ligeramente más anchas que los hombros, baja el cuerpo doblando los codos hasta que el pecho toque el suelo, luego vuelve a la posición inicial extendiendo los brazos.', 1, 1),
    ('Fondos en Paralelas', 'youtube.com', 'Sostente en dos barras paralelas con los brazos extendidos, baja el cuerpo doblando los codos hasta que los hombros estén por debajo de los codos, luego empuja hacia arriba.', 1, 1);

-- Insert exercises for "Peso Libre" type and "Brazos" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Curl de Bíceps', 'youtube.com', 'De pie, sostén una barra con los brazos extendidos y las palmas hacia arriba, dobla los codos para levantar la barra hacia los hombros, luego baja lentamente.', 2, 1),
    ('Martillo con Mancuerna', 'youtube.com', 'De pie, sostén una mancuerna en cada mano con las palmas mirándose entre sí, dobla los codos para levantar las mancuernas hacia los hombros, luego baja lentamente.', 2, 1),
    ('Extensiones de Tríceps con Barra', 'youtube.com', 'De pie, sostén una barra por encima de la cabeza con los brazos extendidos, baja la barra detrás de la cabeza flexionando los codos, luego estira los brazos hacia arriba.', 2, 1),
    ('Tríceps en Polea', 'youtube.com', 'De pie frente a una polea alta, agarra la cuerda con ambas manos y extiende completamente los brazos hacia abajo, luego flexiona los codos para bajar el peso detrás de la cabeza y extiéndelos de nuevo.', 2, 1),
    ('Fondos en Banco', 'youtube.com', 'Siéntate en un banco con las manos agarrando el borde del banco a los lados, levanta las caderas del banco y baja el cuerpo doblando los codos hasta que los brazos estén en ángulo recto, luego vuelve a la posición inicial.', 2, 1);

-- Insert exercises for "Peso Libre" type and "Espalda" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Dominadas', 'youtube.com', 'Agarra una barra con las manos a una distancia ligeramente mayor que el ancho de los hombros, levanta el cuerpo hasta que la barbilla pase la barra, luego baja lentamente hasta la posición inicial.', 3, 1),
    ('Remo con Barra', 'youtube.com', 'De pie, inclínate hacia adelante desde la cintura con la espalda recta, agarra la barra con las manos separadas al ancho de los hombros, levanta la barra hacia el torso manteniendo los codos cerca del cuerpo, luego baja lentamente.', 3, 1),
    ('Peso Muerto', 'youtube.com', 'De pie, sostén una barra con las manos separadas al ancho de los hombros, flexiona las caderas y las rodillas para bajar la barra hacia el suelo, mantén la espalda recta, luego estira las caderas y las rodillas para levantar la barra.', 3, 1),
    ('Hiperextensiones', 'youtube.com', 'Colócate en una máquina de hiperextensiones con los pies sujetos y el torso apoyado, baja el torso hacia abajo doblando la cintura y luego levanta el torso hacia arriba.', 3, 1),
    ('Pull-Ups', 'youtube.com', 'Agarra una barra con las manos a una distancia ligeramente mayor que el ancho de los hombros y las palmas hacia adelante, levanta el cuerpo hasta que la barbilla pase la barra, luego baja lentamente hasta la posición inicial.', 3, 1);

-- Insert exercises for "Peso Libre" type and "Piernas" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Sentadillas', 'youtube.com', 'De pie con los pies separados al ancho de los hombros, baja el cuerpo doblando las rodillas hasta que los muslos estén paralelos al suelo, mantén la espalda recta y el pecho levantado, luego vuelve a la posición inicial.', 4, 1),
    ('Prensa de Piernas', 'youtube.com', 'Siéntate en una máquina de prensa de piernas con los pies en la plataforma y las rodillas dobladas, empuja la plataforma hacia arriba estirando las piernas, luego baja la plataforma lentamente.', 4, 1),
    ('Zancadas', 'youtube.com', 'Da un paso hacia adelante con una pierna y baja el cuerpo doblando ambas rodillas hasta que las rodillas formen ángulos de 90 grados, mantén la espalda recta, luego empuja con la pierna delantera para volver a la posición inicial.', 4, 1),
    ('Elevación de Talones', 'youtube.com', 'De pie con los pies separados al ancho de los hombros, levántate sobre las puntas de los pies contrayendo los músculos de la pantorrilla, luego baja lentamente.', 4, 1),
    ('Peso Muerto Rumano', 'youtube.com', 'De pie con los pies separados al ancho de los hombros, sostén una barra con las manos separadas al ancho de los hombros, baja el torso hacia adelante manteniendo las piernas ligeramente flexionadas, luego vuelve a la posición inicial.', 4, 1);
    
-- Insert exercises for "Calistenia" type and "Pecho" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Fondos en Anillas', 'youtube.com', 'Agarra dos anillas con las manos a una distancia ligeramente mayor que el ancho de los hombros, baja el cuerpo doblando los codos hasta que los hombros estén por debajo de los codos, luego empuja hacia arriba.', 1, 2),
    ('Flexiones Declinadas', 'youtube.com', 'Colócate en posición de plancha con los pies elevados en una plataforma, baja el cuerpo doblando los codos hasta que el pecho toque el suelo, luego vuelve a la posición inicial extendiendo los brazos.', 1, 2),
    ('Flexiones con Palmada', 'youtube.com', 'Realiza una flexión explosiva y en el punto más alto de la flexión, despega las manos del suelo y apláudelas antes de volver a colocarlas en su lugar.', 1, 2),
    ('Flexiones con Manos Juntas', 'youtube.com', 'Coloca las manos juntas debajo del pecho, realiza una flexión manteniendo las manos juntas y el codo cerca del cuerpo.', 1, 2),
    ('Fondos en Pica', 'youtube.com', 'Colócate frente a una silla o banco resistente, apoya las manos en el borde del banco y baja el cuerpo doblando los codos hasta que los hombros estén por debajo de los codos, luego empuja hacia arriba.', 1, 2);

-- Insert exercises for "Calistenia" type and "Brazos" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Flexiones Diamante', 'youtube.com', 'Colócate en posición de plancha con las manos juntas formando un triángulo debajo del pecho, baja el cuerpo doblando los codos hasta que el pecho toque el suelo, luego vuelve a la posición inicial extendiendo los brazos.', 2, 2),
    ('Flexiones Explosivas', 'youtube.com', 'Realiza una flexión explosiva y en el punto más alto de la flexión, despega las manos del suelo.', 2, 2),
    ('Curl de Bíceps en Anillas', 'youtube.com', 'Agarra dos anillas con las manos, flexiona los codos para levantar el cuerpo hacia las anillas.', 2, 2),
    ('Flexiones con Variación de Altura', 'youtube.com', 'Coloca una mano en una plataforma elevada y otra en el suelo, realiza una flexión manteniendo una mano más alta que la otra.', 2, 2),
    ('Flexiones con Tres Puntos de Apoyo', 'youtube.com', 'Coloca una mano en una plataforma elevada, otra en el suelo y otra en una pared, realiza una flexión manteniendo las manos en sus respectivos puntos de apoyo.', 2, 2);

-- Insert exercises for "Calistenia" type and "Espalda" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Dominadas a una Mano', 'youtube.com', 'Agarra la barra con una sola mano, levanta el cuerpo hasta que la barbilla pase la barra, luego baja lentamente hasta la posición inicial.', 3, 2),
    ('Dominadas en L', 'youtube.com', 'Agarra una barra con las manos a una distancia ligeramente mayor que el ancho de los hombros, levanta las piernas hacia el torso para formar una "L", luego levanta el cuerpo hasta que la barbilla pase la barra.', 3, 2),
    ('Flexiones con Peso', 'youtube.com', 'Coloca un peso adicional en la espalda y realiza flexiones manteniendo una postura adecuada.', 3, 2),
    ('Flexiones en Anillas', 'youtube.com', 'Agarra dos anillas con las manos y realiza flexiones manteniendo el equilibrio.', 3, 2),
    ('Levantamiento de Cuerpo en Barra', 'youtube.com', 'Colócate en una barra baja y realiza un levantamiento de cuerpo llevando el pecho hacia la barra.', 3, 2);

-- Insert exercises for "Calistenia" type and "Piernas" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Sentadillas Pistola', 'youtube.com', 'De pie con una pierna extendida hacia adelante, baja el cuerpo flexionando la rodilla de la pierna de apoyo hasta que la pierna extendida casi toque el suelo, luego vuelve a la posición inicial.', 4, 2),
    ('Estocadas', 'youtube.com', 'De pie con los pies separados al ancho de los hombros, da un paso hacia adelante con una pierna y flexiona ambas rodillas hasta que ambas piernas estén en ángulos de 90 grados, luego regresa a la posición inicial y repite con la otra pierna.', 4, 2),
    ('Step Ups', 'youtube.com', 'Coloca un banco resistente frente a ti, coloca un pie en el banco y empuja hacia arriba con la pierna en el banco hasta que esté extendida, luego baja y repite con la otra pierna.', 4, 2),
    ('Elevación de Piernas en Barra Fija', 'youtube.com', 'Colócate en una barra fija con los brazos extendidos, levanta las piernas hacia arriba flexionando las caderas y las rodillas, luego baja lentamente.', 4, 2),
    ('Sentadillas con Salto', 'youtube.com', 'De pie con los pies separados al ancho de los hombros, baja el cuerpo flexionando las rodillas y las caderas como si fueras a sentarte en una silla, luego salta explosivamente hacia arriba extendiendo las piernas, luego aterriza suavemente y vuelve a la posición inicial.', 4, 2);

-- Insert exercises for "Cardio" type and "Pecho" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Burpees', 'youtube.com', 'Comienza de pie, luego baja al suelo en posición de flexión, haz una flexión, salta hacia adelante, y luego realiza un salto vertical con las manos en alto.', 1, 3),
    ('Mountain Climbers', 'youtube.com', 'Comienza en posición de plancha, luego lleva alternativamente las rodillas hacia el pecho lo más rápido posible, manteniendo una postura adecuada.', 1, 3),
    ('Flexiones de Brazos con Salto', 'youtube.com', 'Realiza una flexión de brazos y al subir, realiza un salto vertical con las manos en alto.', 1, 3),
    ('Flexiones Explosivas', 'youtube.com', 'Realiza una flexión explosiva y en el punto más alto de la flexión, despega las manos del suelo.', 1, 3),
    ('Circuito de Flexiones y Saltos', 'youtube.com', 'Realiza un circuito alternando entre flexiones de brazos y saltos verticales, manteniendo una buena técnica en cada ejercicio.', 1, 3);

-- Insert exercises for "Cardio" type and "Brazos" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Jumping Jacks', 'youtube.com', 'Comienza de pie con los pies juntos, luego salta abriendo los pies hacia los lados y levantando los brazos por encima de la cabeza, luego vuelve a la posición inicial.', 2, 3),
    ('Carrera en el Lugar', 'youtube.com', 'Corre en el lugar levantando las rodillas hacia el pecho lo más alto posible.', 2, 3),
    ('Burpees', 'youtube.com', 'Comienza de pie, luego baja al suelo en posición de flexión, haz una flexión, salta hacia adelante, y luego realiza un salto vertical con las manos en alto.', 2, 3),
    ('Plancha con Palmadas', 'youtube.com', 'Comienza en posición de plancha y da palmadas alternativamente con cada mano, manteniendo una postura adecuada.', 2, 3),
    ('Flexiones Explosivas con Palmada', 'youtube.com', 'Realiza flexiones explosivas y en el aire, aplaude las manos antes de volver a la posición inicial.', 2, 3);

-- Insert exercises for "Cardio" type and "Espalda" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Escaladores', 'youtube.com', 'Comienza en posición de plancha y lleva alternativamente las rodillas hacia el pecho lo más rápido posible, manteniendo una postura adecuada.', 3, 3),
    ('Jumping Jacks', 'youtube.com', 'Comienza de pie con los pies juntos, luego salta abriendo los pies hacia los lados y levantando los brazos por encima de la cabeza, luego vuelve a la posición inicial.', 3, 3),
    ('Mountain Climbers', 'youtube.com', 'Comienza en posición de plancha, luego lleva alternativamente las rodillas hacia el pecho lo más rápido posible, manteniendo una postura adecuada.', 3, 3),
    ('Plancha con Palmadas', 'youtube.com', 'Comienza en posición de plancha y da palmadas alternativamente con cada mano, manteniendo una postura adecuada.', 3, 3),
    ('Flexiones Explosivas con Palmada', 'youtube.com', 'Realiza flexiones explosivas y en el aire, aplaude las manos antes de volver a la posición inicial.', 3, 3);

-- Insert exercises for "Cardio" type and "Piernas" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Burpees con Salto', 'youtube.com', 'Comienza de pie, luego baja al suelo en posición de flexión, haz una flexión, salta hacia adelante, y luego realiza un salto vertical con las manos en alto.', 4, 3),
    ('Sentadillas con Salto', 'youtube.com', 'De pie con los pies separados al ancho de los hombros, baja el cuerpo flexionando las rodillas y las caderas como si fueras a sentarte en una silla, luego salta explosivamente hacia arriba extendiendo las piernas, luego aterriza suavemente y vuelve a la posición inicial.', 4, 3),
    ('Jumping Lunges', 'youtube.com', 'Da un paso hacia adelante con una pierna y flexiona ambas rodillas hasta que ambas piernas estén en ángulos de 90 grados, luego salta y cambia la posición de las piernas en el aire, aterrizando con la otra pierna hacia adelante.', 4, 3),
    ('Mountain Climbers Rápidos', 'youtube.com', 'Comienza en posición de plancha, luego lleva alternativamente las rodillas hacia el pecho lo más rápido posible, manteniendo una postura adecuada.', 4, 3),
    ('Salto al Cajón', 'youtube.com', 'Colócate frente a un cajón resistente, baja el cuerpo flexionando las rodillas y las caderas, luego salta explosivamente hacia arriba y aterriza suavemente en el cajón, luego baja y repite.', 4, 3);

-- Insert exercises for "Maquina" type and "Pecho" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Press de Pecho en Máquina', 'youtube.com', 'Siéntate en la máquina de press de pecho, agarra las empuñaduras y empuja hacia adelante hasta que los brazos estén extendidos, luego vuelve a la posición inicial.', 1, 4),
    ('Butterfly en Máquina', 'youtube.com', 'Siéntate en la máquina de mariposa con los codos doblados a 90 grados, luego junta los codos frente al pecho contra la resistencia y luego vuelve a la posición inicial.', 1, 4),
    ('Press Inclinado en Máquina', 'youtube.com', 'Siéntate en la máquina de press inclinado, agarra las empuñaduras y empuja hacia arriba hasta que los brazos estén extendidos, luego vuelve a la posición inicial.', 1, 4),
    ('Press Declinado en Máquina', 'youtube.com', 'Siéntate en la máquina de press declinado, agarra las empuñaduras y empuja hacia abajo hasta que los brazos estén extendidos, luego vuelve a la posición inicial.', 1, 4),
    ('Pull-Over en Máquina', 'youtube.com', 'Siéntate en la máquina de pull-over con los brazos extendidos hacia arriba, baja los brazos hacia atrás y hacia abajo hasta que sientas un estiramiento en el pecho y luego vuelve a la posición inicial.', 1, 4);

-- Insert exercises for "Maquina" type and "Brazos" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Curl de Bíceps en Máquina', 'youtube.com', 'Siéntate en la máquina de curl de bíceps, agarra las empuñaduras y flexiona los codos hacia los hombros, luego baja lentamente.', 2, 4),
    ('Extensiones de Tríceps en Máquina', 'youtube.com', 'Siéntate en la máquina de extensiones de tríceps con los brazos extendidos hacia arriba, baja la empuñadura hacia abajo flexionando los codos, luego estira los brazos hacia arriba.', 2, 4),
    ('Martillo en Máquina', 'youtube.com', 'Siéntate en la máquina de martillo con los brazos a los lados, flexiona los codos para levantar las empuñaduras hacia los hombros, luego baja lentamente.', 2, 4),
    ('Curl de Bíceps Alternado en Máquina', 'youtube.com', 'Siéntate en la máquina de curl de bíceps con los brazos extendidos hacia abajo, flexiona un codo para levantar la empuñadura hacia el hombro, luego baja y repite con el otro brazo.', 2, 4),
    ('Press Francés en Máquina', 'youtube.com', 'Siéntate en la máquina de press francés con los brazos extendidos hacia arriba, baja la empuñadura detrás de la cabeza flexionando los codos, luego estira los brazos hacia arriba.', 2, 4);

-- Insert exercises for "Maquina" type and "Espalda" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Dominadas Asistidas en Máquina', 'youtube.com', 'Siéntate en la máquina de dominadas asistidas, agarra las empuñaduras y baja el cuerpo hasta que los brazos estén extendidos, luego sube el cuerpo flexionando los codos.', 3, 4),
    ('Polea Alta en Máquina', 'youtube.com', 'Siéntate frente a la máquina de polea alta, agarra la barra con las manos y baja la barra hacia abajo flexionando los codos, luego estira los brazos hacia arriba.', 3, 4),
    ('Polea Baja en Máquina', 'youtube.com', 'Siéntate frente a la máquina de polea baja, agarra las empuñaduras con las manos y tira de ellas hacia abajo, llevando los codos hacia atrás, luego lleva las manos hacia adelante hasta que los brazos estén extendidos.', 3, 4),
    ('Remo en Máquina', 'youtube.com', 'Siéntate en la máquina de remo con los pies en los soportes y agarra las empuñaduras con las manos, tira de las empuñaduras hacia el torso manteniendo la espalda recta, luego estira los brazos hacia adelante.', 3, 4),
    ('Pull-Down en Máquina', 'youtube.com', 'Siéntate frente a la máquina de pull-down, agarra la barra con las manos y tira de ella hacia abajo, llevando los codos hacia atrás, luego lleva las manos hacia arriba hasta que los brazos estén extendidos.', 3, 4);

-- Insert exercises for "Maquina" type and "Piernas" category
INSERT INTO exercise (exercise_name, link_video, description, fk_category_1, fk_id_type)
VALUES 
    ('Extensión de Piernas en Máquina', 'youtube.com', 'Siéntate en la máquina de extensión de piernas, coloca los pies detrás de las almohadillas y empuja hacia adelante extendiendo las rodillas, luego vuelve a la posición inicial.', 4, 4),
    ('Curl de Piernas en Máquina', 'youtube.com', 'Siéntate en la máquina de curl de piernas, coloca los pies detrás de las almohadillas y flexiona las rodillas hacia el torso, luego baja lentamente.', 4, 4),
    ('Sentadillas Hack', 'youtube.com', 'Colócate frente a la máquina de sentadillas hack, coloca los hombros bajo los cojines y baja el cuerpo flexionando las rodillas y las caderas, luego empuja hacia arriba.', 4, 4),
    ('Curl de Piernas Unilateral en Máquina', 'youtube.com', 'Siéntate en la máquina de curl de piernas, coloca un pie detrás de la almohadilla y flexiona la rodilla hacia el torso, luego baja lentamente.', 4, 4),
    ('Prensa de Piernas Inclinada', 'youtube.com', 'Siéntate en la máquina de prensa de piernas inclinada, coloca los pies en la plataforma y empuja la plataforma hacia arriba extendiendo las rodillas, luego baja lentamente.', 4, 4);
   

/* EXAMPLE USERS */
/* SHOULD THIS REALLY BE HERE?????? */
INSERT INTO users (username, email, pssd, urole, foto) VALUES ("jacob", "marcel.esplu@gmail.com", "$2b$10$A9e6CsQ460fgzbkD0EbF7uA2.hte.tLZ8dfbCni2UCYoLIU3AIs52", 1, null);
INSERT INTO users (username, email, pssd, urole, foto) VALUES ("arcedo", "marc.arcedo@gmail.com", "$2b$10$Yf8TMCyZzggKAgNd.qMNHOyfnhhuHJtoaX2AqZVZCoyU8hkn4t7RS", 2, null);
INSERT INTO users (username, email, pssd, urole, foto) VALUES ("prova", "prova@gmail.com", "$2b$10$Yf8TMCyZzggKAgNd.qMNHOyfnhhuHJtoaX2AqZVZCoyU8hkn4t7RS", 3, null);

/*
--EXAMPLE ROUTINES

THIS SHOULD HAVE BEEN COMMENTED OUT
INSERT INTO routines (routine_name, type_routine, num_routine, fk_id_username) VALUES ("prueba01", "libre", 5, 1);
INSERT INTO routines (routine_name, type_routine, day_routine , fk_id_username) VALUES ("prueba02", "semanal", "[\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\"]", 1);
INSERT INTO routines (routine_name, type_routine, num_routine, fk_id_username) VALUES ("arcedo_exercise", "libre", 4, 2);

--EXAMPLE SESSIONS

INSERT INTO sessions (nom_session, week_day, fk_category_1, fk_category_2, fk_id_routine) VALUES ("Martes", "Tuesday", null, null, 2);
INSERT INTO sessions (nom_session, week_day, fk_category_1, fk_category_2, fk_id_routine) VALUES ("Miercoles", "Wednesday", null, null, 2);
INSERT INTO sessions (nom_session, week_day, fk_category_1, fk_category_2, fk_id_routine) VALUES ("Jueves", "Thursday", null, null, 2);
INSERT INTO sessions (nom_session, week_day, fk_category_1, fk_category_2, fk_id_routine) VALUES ("Viernes", "Friday", null, null, 2);
*/