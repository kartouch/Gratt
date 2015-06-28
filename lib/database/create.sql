CREATE TABLE wishlists(
  id serial primary key,
  title varchar(255) NOT NULL,
  season varchar(2),
  episode varchar(2),
  lang varchar(12)
);

CREATE TABLE torrents(
  id serial primary key,
  wishlist_id integer,
  available boolean,
  downloaded boolean
);
