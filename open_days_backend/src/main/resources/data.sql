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

--Organizer emails
INSERT INTO organizer_emails (id, email) VALUES (1, 'anomakyr@gmail.com')

--Counties
INSERT INTO counties (id, name) VALUES (1, 'Kovászna')
INSERT INTO counties (id, name) VALUES (2, 'Hargita')
INSERT INTO counties (id, name) VALUES (3, 'Maros')

--Settlements
INSERT INTO settlements (id, name, county_id) VALUES (1, 'Balánbánya', 2)
INSERT INTO settlements (id, name, county_id) VALUES (2, 'Borszék', 2)
INSERT INTO settlements (id, name, county_id) VALUES (3, 'Csíkszentmárton', 2)
INSERT INTO settlements (id, name, county_id) VALUES (4, 'Csíkszereda', 2)
INSERT INTO settlements (id, name, county_id) VALUES (5, 'Dánfalva', 2)
INSERT INTO settlements (id, name, county_id) VALUES (6, 'Ditró', 2)
INSERT INTO settlements (id, name, county_id) VALUES (7, 'Gyergyóalfalu', 2)
INSERT INTO settlements (id, name, county_id) VALUES (8, 'Gyergyóholló', 2)
INSERT INTO settlements (id, name, county_id) VALUES (9, 'Gyergyószentmiklós', 2)
INSERT INTO settlements (id, name, county_id) VALUES (10, 'Gyergyóvárhegy', 2)
INSERT INTO settlements (id, name, county_id) VALUES (11, 'Gyímesfelsőlok', 2)
INSERT INTO settlements (id, name, county_id) VALUES (12, 'Korond', 2)
INSERT INTO settlements (id, name, county_id) VALUES (13, 'Maroshévíz', 2)
INSERT INTO settlements (id, name, county_id) VALUES (14, 'Székelykeresztúr', 2)
INSERT INTO settlements (id, name, county_id) VALUES (15, 'Székelyudvarhely', 2)
INSERT INTO settlements (id, name, county_id) VALUES (16, 'Szentegyháza', 2)
INSERT INTO settlements (id, name, county_id) VALUES (17, 'Zetelaka', 2)

INSERT INTO settlements (id, name, county_id) VALUES (18, 'Marosvásárhely', 3)

--Institutions
INSERT INTO institutions (id, name, settlement_id) VALUES (1, 'Liviu Rebreanu Szakközépiskola', 1)
INSERT INTO institutions (id, name, settlement_id) VALUES (2, 'Zimmethausen Szaklíceum', 2)
INSERT INTO institutions (id, name, settlement_id) VALUES (3, 'Tivai Nagy Imre Szakközépiskola', 3)
INSERT INTO institutions (id, name, settlement_id) VALUES (4, 'Márton Áron Főgimnázium', 4)
INSERT INTO institutions (id, name, settlement_id) VALUES (5, 'Segítő Mária Római Katolikus Gimnázium', 4)
INSERT INTO institutions (id, name, settlement_id) VALUES (6, 'Kájoni János Szakközépiskola', 4)
INSERT INTO institutions (id, name, settlement_id) VALUES (7, 'Octavian Goga Főgimnázium', 4)
INSERT INTO institutions (id, name, settlement_id) VALUES (8, 'Kós Károly Szakközépiskola', 4)
INSERT INTO institutions (id, name, settlement_id) VALUES (9, 'Venczel József Szakközépiskola', 4)
INSERT INTO institutions (id, name, settlement_id) VALUES (10, 'Székely Károly Szakközépiskola', 4)
INSERT INTO institutions (id, name, settlement_id) VALUES (11, 'Petőfi Sándor Iskolaközpont', 5)
INSERT INTO institutions (id, name, settlement_id) VALUES (12, 'Puskás Tivadar Szakközépiskola', 6)
INSERT INTO institutions (id, name, settlement_id) VALUES (13, 'Sövér Elek Szakközépiskola', 7)
INSERT INTO institutions (id, name, settlement_id) VALUES (14, 'Gyergyóhollói Szakközépiskola', 8)
INSERT INTO institutions (id, name, settlement_id) VALUES (15, 'Salamon Ernő Gimnázium', 9)
INSERT INTO institutions (id, name, settlement_id) VALUES (16, 'Batthyany Ignác Technikai Kollégium', 9)
INSERT INTO institutions (id, name, settlement_id) VALUES (17, 'Sfântu Nicolae Gimnázium', 9)
INSERT INTO institutions (id, name, settlement_id) VALUES (18, 'Fogarasy Mihály Szakközépiskola', 9)
INSERT INTO institutions (id, name, settlement_id) VALUES (19, 'Miron Cristea Líceum', 10)
INSERT INTO institutions (id, name, settlement_id) VALUES (20, 'Árpád-házi Szent Erzsébet Római Katolikus Teológiai Líceum', 11)
INSERT INTO institutions (id, name, settlement_id) VALUES (21, 'Korondi Szakközépiskola', 12)
INSERT INTO institutions (id, name, settlement_id) VALUES (22, 'O.C. Tăslăuanu Gimnázium', 13)
INSERT INTO institutions (id, name, settlement_id) VALUES (23, 'Kemény János Elméleti Líceum', 13)
INSERT INTO institutions (id, name, settlement_id) VALUES (24, 'Mihai Eminescu Főgimnázium', 13)
INSERT INTO institutions (id, name, settlement_id) VALUES (25, 'Berde Mózes Unitárius Gimnázium', 14)
INSERT INTO institutions (id, name, settlement_id) VALUES (26, 'Orbán Balázs Gimnázium', 14)
INSERT INTO institutions (id, name, settlement_id) VALUES (27, 'Tamási Áron Gimnázium', 15)
INSERT INTO institutions (id, name, settlement_id) VALUES (28, 'Benedek Elek Pedagógiai Líceum', 15)
INSERT INTO institutions (id, name, settlement_id) VALUES (29, 'Baczkamadarasi Kis Gergely Református Kollégium', 15)
INSERT INTO institutions (id, name, settlement_id) VALUES (30, 'Kós Károly Szakközépiskola', 15)
INSERT INTO institutions (id, name, settlement_id) VALUES (31, 'Eötvos József Szakközépiskola', 15)
INSERT INTO institutions (id, name, settlement_id) VALUES (32, 'Marin Preda Líceum', 15)
INSERT INTO institutions (id, name, settlement_id) VALUES (33, 'Bányai János Műszaki Szakközépiskola', 15)
INSERT INTO institutions (id, name, settlement_id) VALUES (34, 'Gábor Áron Szakközépiskola', 16)
INSERT INTO institutions (id, name, settlement_id) VALUES (35, 'Dr. P. Boros Fortunát Elméleti Kozepiskola', 17)

INSERT INTO institutions (id, name, settlement_id) VALUES (36, 'Bólyai Farkas Líceum', 18)
INSERT INTO institutions (id, name, settlement_id) VALUES (37, 'Sapientia EMTE', 18)

--Roles
INSERT INTO roles (id, name) VALUES (1, 'ROLE_USER')
INSERT INTO roles (id, name) VALUES (2, 'ROLE_ORGANIZER')
INSERT INTO roles (id, name) VALUES (3, 'ROLE_ADMIN')

--Authorities
INSERT INTO authorities (id, name) VALUES (1, 'READ_AUTHORITY')
INSERT INTO authorities (id, name) VALUES (2, 'WRITE_AUTHORITY')
INSERT INTO authorities (id, name) VALUES (3, 'DELETE_AUTHORITY')

--Users
--Admin
INSERT INTO users (id, email, email_verification_status, email_verification_token, encrypted_password, first_name, last_name, otp_code, public_id, username, institution_id, image_path, role_id) VALUES (1, 'admin@mailinator.com', true, NULL, '$2a$10$z9BeqAxh0nY.kdpuvDi.xuP0mwIPgqK2WPtkTghwX3iAJJoHQ0MMm', 'John', 'Doe', NULL, 'qwertyuiopasdf1', 'admin', 37, NULL, 3)

--Organizers
INSERT INTO users (id, email, email_verification_status, email_verification_token, encrypted_password, first_name, last_name, otp_code, public_id, username, institution_id, image_path, role_id) VALUES (2, 'geergely.zsolt@gmail.com', true, NULL, '$2a$10$z9BeqAxh0nY.kdpuvDi.xuP0mwIPgqK2WPtkTghwX3iAJJoHQ0MMm', 'Zsolt', 'Gergely', NULL, 'qwertyuiopasdf2', 'organizer', 37, 'user/placeholder.jpg', 2)
INSERT INTO users (id, email, email_verification_status, email_verification_token, encrypted_password, first_name, last_name, otp_code, public_id, username, institution_id, image_path, role_id) VALUES (3, 'csenge.albert.toth@mailinator.com', true, NULL, '$2a$10$z9BeqAxh0nY.kdpuvDi.xuP0mwIPgqK2WPtkTghwX3iAJJoHQ0MMm', 'Csenge', 'Albert-Tóth', NULL, 'qwertyuiopasdf3', 'csenge', 37, NULL, 2)

--Users
INSERT INTO users (id, email, email_verification_status, email_verification_token, encrypted_password, first_name, last_name, otp_code, public_id, username, institution_id, image_path, role_id) VALUES (4, 'user@mailinator.com', true, NULL, '$2a$10$z9BeqAxh0nY.kdpuvDi.xuP0mwIPgqK2WPtkTghwX3iAJJoHQ0MMm', 'Marci', 'Puck', NULL, 'qwertyuiopasdf4', 'user', 4, NULL, 1)


--Activities
INSERT INTO activities (id, name) VALUES (1, 'Kampusztúra')
INSERT INTO activities (id, name) VALUES (2, 'Gépészmérnöki tanszékbemutató')
INSERT INTO activities (id, name) VALUES (3, 'Kertészmérnöki tanszékbemutató')
INSERT INTO activities (id, name) VALUES (4, 'Villamosmérnöki tanszékbemutató')
INSERT INTO activities (id, name) VALUES (5, 'Matematika-Informatika tanszékbemutató')
INSERT INTO activities (id, name) VALUES (6, 'Alkalmazott Nyelvészeti tanszékbemutató')
INSERT INTO activities (id, name) VALUES (7, 'Alkalmazott Társadalomtudomanyok tanszékbemutató')

--Events
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (1, '2024-03-01 10:15', 'event/placeholder.jpg', false, 'Sapientia', NULL, 1, 2, 'A kampusztúrán bemutatjuk az érdeklődőknek az egyetem épületét. Érintve akönyvtárat, a Hallgató Önkormányzatot (HÖK), a sportpályát, a bentlakás épületét és a közösségi terünket,a placcot.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (2, '2024-03-01 11:20', 'event/placeholder.jpg', false, '312-es terem', NULL, 2, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (3, '2024-03-10 15:30', 'event/placeholder.jpg', false, 'Sportpálya', NULL, 3, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (4, '2024-03-15 09:30', 'event/placeholder.jpg', false, '114-es terem', NULL, 4, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (5, '2024-04-02 22:30', 'event/placeholder.jpg', false, '114-es tanterem', NULL, 5, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (6, '2024-04-22 19:45', 'event/placeholder.jpg', false, 'Aula', NULL, 6, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (7, '2024-05-26 07:12', 'event/placeholder.jpg', false, '1. emelet', NULL, 7, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (8, '2024-05-08 09:10', 'event/placeholder.jpg', true, '2. emelet', 'https://meeting.com', 1, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (9, '2022-05-08 09:10', 'event/placeholder.jpg', true, '2. emelet', 'https://meeting.com', 1, 3, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')
INSERT INTO events (id, date_time, image_link, is_online, location, meeting_link, activity_id, organizer_id, description) VALUES (10, '2024-08-08 09:10', 'event/placeholder.jpg', true, '2. emelet', 'https://meeting.com', 1, 3, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took agalley of type and scrambled it to make a type specimen book.')

--Roles-authorities
INSERT INTO roles_authorities (roles_id, authorities_id) VALUES (1, 1)
INSERT INTO roles_authorities (roles_id, authorities_id) VALUES (1, 2)
INSERT INTO roles_authorities (roles_id, authorities_id) VALUES (2, 1)
INSERT INTO roles_authorities (roles_id, authorities_id) VALUES (2, 2)
INSERT INTO roles_authorities (roles_id, authorities_id) VALUES (3, 1)
INSERT INTO roles_authorities (roles_id, authorities_id) VALUES (3, 2)
INSERT INTO roles_authorities (roles_id, authorities_id) VALUES (3, 3)