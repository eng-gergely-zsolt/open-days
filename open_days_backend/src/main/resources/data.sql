DELETE FROM users_roles
DELETE FROM users_events
DELETE FROM roles_authorities
DELETE FROM participated_users
DELETE FROM password_reset_tokens

DELETE FROM events
DELETE FROM users
DELETE FROM roles
DELETE FROM activities
DELETE FROM authorities

DELETE FROM institutions
DELETE FROM settlements
DELETE FROM counties
DELETE FROM organizer_emails

--Counties
INSERT INTO counties (id, name) VALUES (NULL, 'Covasna')
INSERT INTO counties (id, name) VALUES (NULL, 'Harghita')
INSERT INTO counties (id, name) VALUES (NULL, 'Mures')

--Settlements
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Balanbanya', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Borszek', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Csikszentmarton', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Csikszereda', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Danfalva', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Ditro', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Gyergyoalfalu', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Gyergyohollo', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Gyergyoszentmiklos', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Gyergyovarhegy', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Gyimesfelsolok', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Korond', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Marosheviz', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Szekelykeresztur', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Szekelyudvarhely', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Szentegyhaza', get_county_id('Harghita'))
INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Zetelaka', get_county_id('Harghita'))

INSERT INTO settlements (id, name, county_id) VALUES (NULL, 'Marosvasarhely', get_county_id('Mures'))

--Institutions
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Bolyai Farkas Liceum', get_settlement_id('Marosvasarhely'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Liviu Rebreanu Szakkozepiskola', get_settlement_id('Balanbanya'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Zimmethausen Szakliceum', get_settlement_id('Borszek'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Tivai Nagy Imre Szakkozepiskola', get_settlement_id('Csikszentmarton'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Marton Aron Fogimnazium', get_settlement_id('Csikszereda'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Segito Maria Romai Katolikus Gimnazium', get_settlement_id('Csikszereda'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Joannes Kajoni Szakkozepiskola', get_settlement_id('Csikszereda'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Octavian Goga Fogimnazium', get_settlement_id('Csikszereda'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Kos Karoly Szakkozepiskola', get_settlement_id('Csikszereda'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Venczel Jozsef Szakkozepiskola', get_settlement_id('Csikszereda'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Szekely Karoly Szakkozepiskola', get_settlement_id('Csikszereda'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Petofi Sandor Iskolakozpont', get_settlement_id('Danfalva'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Puskas Tivadar Szakkozepiskola', get_settlement_id('Ditro'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Sover Elek Szakkozepiskola', get_settlement_id('Gyergyoalfalu'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Gyergyoholloi Szakkozepiskola', get_settlement_id('Gyergyohollo'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Salamon Erno Gimnazium', get_settlement_id('Gyergyoszentmiklos'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Batthyany Ignac Technikai Kollegium', get_settlement_id('Gyergyoszentmiklos'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Sfantu Nicolae Gimnazium', get_settlement_id('Gyergyoszentmiklos'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Fogarasy Mihaly Szakkozepiskola', get_settlement_id('Gyergyoszentmiklos'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Miron Cristea Liceum', get_settlement_id('Gyergyovarhegy'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Arpad-hazi Szent Erzsebet Romai Katolikus Teologiai Liceum', get_settlement_id('Gyimesfelsolok'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Korondi Szakkozepiskola', get_settlement_id('Korond'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'O.C. Taslauanu Gimnazium', get_settlement_id('Marosheviz'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Kemeny Janos Elmeleti Liceum', get_settlement_id('Marosheviz'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Mihai Eminescu Fogimnazium', get_settlement_id('Marosheviz'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Berde Mozes Unitarius Gimnazium', get_settlement_id('Szekelykeresztur'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Orban Balazs Gimnazium', get_settlement_id('Szekelykeresztur'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Tamasi Aron Gimnazium', get_settlement_id('Szekelyudvarhely'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Benedek Elek Pedagogiai Liceum', get_settlement_id('Szekelyudvarhely'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Baczkamadarasi Kis Gergely Reformatus Kollegium', get_settlement_id('Szekelyudvarhely'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Kos Karoly Szakkozepiskola', get_settlement_id('Szekelyudvarhely'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Eotvos Jozsef Szakkozepiskola', get_settlement_id('Szekelyudvarhely'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Marin Preda Liceum', get_settlement_id('Szekelyudvarhely'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Banyai Janos Muszaki Szakkozepiskola', get_settlement_id('Szekelyudvarhely'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Gabor Aron Szakkozepiskola', get_settlement_id('Szentegyhaza'))
INSERT INTO institutions (id, name, settlement_id) VALUES (NULL, 'Dr. P. Boros Fortunat Elmeleti Kozepiskola', get_settlement_id('Zetelaka'))

--Organizer emails
INSERT INTO organizer_emails (id, email) VALUES (NULL, 'anomakyr@gmail.com')
INSERT INTO organizer_emails (id, email) VALUES (NULL, 'organizer1@gmail.com')
INSERT INTO organizer_emails (id, email) VALUES (NULL, 'organizer2@gmail.com')

--Roles
INSERT INTO roles (id, name) VALUES (NULL, 'ROLE_USER')
INSERT INTO roles (id, name) VALUES (NULL, 'ROLE_ORGANIZER')
INSERT INTO roles (id, name) VALUES (NULL, 'ROLE_ADMIN')

--Authorities
INSERT INTO authorities (id, name) VALUES (NULL, 'READ_AUTHORITY')
INSERT INTO authorities (id, name) VALUES (NULL, 'WRITE_AUTHORITY')
INSERT INTO authorities (id, name) VALUES (NULL, 'DELETE_AUTHORITY')

--Activities
INSERT INTO activities (id, name) VALUES (NULL, 'Kampusztura')
INSERT INTO activities (id, name) VALUES (NULL, 'Kerteszmernoki tanszek')
INSERT INTO activities (id, name) VALUES (NULL, 'Gepeszmernoki Tanszek bemutato')
INSERT INTO activities (id, name) VALUES (NULL, 'Villamosmernoki Tanszek bemutato')
INSERT INTO activities (id, name) VALUES (NULL, 'Matematika-Informatika Tanszek bemutato')
INSERT INTO activities (id, name) VALUES (NULL, 'Alkalmazott Nyelveszeti Tanszek bemutato')
INSERT INTO activities (id, name) VALUES (NULL, 'Alkalmazott Tarsadalomtudomanyok Tanszek bemutato')