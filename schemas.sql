create table users (
    user_id serial primary key, 
    username varchar (50) unique not null, 
    birthdate date not null,
    email varchar (50) unique not null, 
    contactno bigint not null
);

create table cycles (
    cycle_id serial primary key, 
    user_id integer, 
    foreign key (user_id) references users(user_id),
    start_date date,
    end_date date,
    flow_intensity integer check (flow_intensity between 1 and 5)
);

create table symptoms (
    symptom_id serial primary key, 
    cycle_id integer, 
    foreign key (cycle_id) references cycles(cycle_id),
    symptom varchar (50),
    severity integer check (severity between 1 and 5),
    notes varchar (50)
);