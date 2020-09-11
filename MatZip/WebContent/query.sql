CREATE TABLE t_user(
	i_user INT unsigned PRIMARY KEY AUTO_INCREMENT,
	user_id varchar(30) NOT NULL UNIQUE,
	user_pw varchar(70) NOT NULL,
	salt VARCHAR(30) NOT NULL,
	nm       varchar(5) NOT NULL,
	profile_img VARCHAR(50),
	r_dt DATETIME DEFAULT NOW(),
	m_dt DATETIME DEFAULT NOW()
);