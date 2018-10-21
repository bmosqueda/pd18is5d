-- Catalogs
  CREATE TABLE Schools(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(250) NOT NULL
  );

  CREATE TABLE Categories(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
  );

  /* Se validará que sólo se guarden letras y números, 
    sin otro tipo de caracteres 
    (los espacios se cambiarán por _)
  */
  CREATE TABLE Keywords(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Keyword VARCHAR(50) NOT NULL
  );

  CREATE TABLE Areas(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
  );

  CREATE TABLE Authors(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(250) NOT NULL,
    alias VARCHAR(100) NOT NULL,
    country_of_birth VARCHAR(100) NOT NULL
  );

-- Main tables
  CREATE TABLE Users(
    account_number VARCHAR(10) NOT NULL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    -- Admin = 1, validotor = 2 and common = 3
    role ENUM('admin', 'validator', 'common') NOT NULL,  
    school_id INT NOT NULL,
    CONSTRAINT email_unique UNIQUE (email),
    CONSTRAINT school_reference_users 
      FOREIGN KEY (school_id)
      REFERENCES Schools(id)
  );

  CREATE TABLE Repositories(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    creator_account_number VARCHAR(10) NOT NULL,
    name VARCHAR(300) NOT NULL,
    url VARCHAR(400) NOT NULL,
    CONSTRAINT creator_reference_repositories
      FOREIGN KEY (creator_account_number)
      REFERENCES Users(account_number)
  );

  CREATE TABLE Resources(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    -- in MB
    size INT NOT NULL,
    -- The resources only can belong to one repository
    repository_owner_id INT NOT NULL,
    type ENUM('video', 'audio', 'book', 'document', 'other') NOT NULL,
    url VARCHAR(400) NOT NULL,
    CONSTRAINT repository_reference_resources
      FOREIGN KEY (repository_owner_id)
      REFERENCES Repositories(id)
  );

-- Intermeadiate tables
  /*DELETE THIS TABLE*/
  CREATE TABLE Repositories_user(
    repository_id INT NOT NULL,
    user_account_number VARCHAR(10) NOT NULL,
    CONSTRAINT repository_reference_repositories_user
      FOREIGN KEY (repository_id)
      REFERENCES Repositories(id),
    CONSTRAINT user_reference_repositories_user
      FOREIGN KEY (user_account_number)
      REFERENCES Users(account_number),
    CONSTRAINT repository_unique_repositories_user UNIQUE (repository_id),
    PRIMARY KEY (repository_id, user_account_number)
  );

  CREATE TABLE Categories_repository(
    repository_id INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT repository_reference_categories_repository
      FOREIGN KEY (repository_id)
      REFERENCES Repositories(id),
    CONSTRAINT category_reference_categories_repository
      FOREIGN KEY (category_id)
      REFERENCES Categories(id),
    PRIMARY KEY (repository_id, category_id)
  );

  -- En lugar de guardar las etiquestas del repositorio, mejor se guardan qué repositorios tienen qué etiquetas
  CREATE TABLE Repositories_with_keyword(
    repository_id INT NOT NULL,
    keyword_id INT NOT NULL,
    CONSTRAINT repository_reference_repositories_keyword
      FOREIGN KEY (repository_id)
      REFERENCES Repositories(id),
    CONSTRAINT keyword_reference_repositories_keyword 
      FOREIGN KEY (keyword_id)
      REFERENCES Keywords(id),
    PRIMARY KEY (repository_id, keyword_id)
  );

  CREATE TABLE Areas_resource(
    area_id INT NOT NULL,
    resource_id INT NOT NULL,
    CONSTRAINT area_reference_areas_resource 
      FOREIGN KEY (area_id)
      REFERENCES Areas(id),
    CONSTRAINT resource_reference_areas_resource
      FOREIGN KEY (resource_id)
      REFERENCES Resources(id),
    PRIMARY KEY (area_id, resource_id)
  );

  CREATE TABLE Authors_resource(
    author_id INT NOT NULL,
    resource_id INT NOT NULL,
    CONSTRAINT author_reference_authors_resource 
      FOREIGN KEY (author_id)
      REFERENCES Authors(id),
    CONSTRAINT resource_reference_authors_resource 
      FOREIGN KEY (resource_id)
      REFERENCES Resources(id),
    PRIMARY KEY (author_id, resource_id)
  );

  CREATE TABLE Resources_repository(
    repository_id INT NOT NULL,
    resource_id INT NOT NULL,
    CONSTRAINT repository_reference_resources_repository 
      FOREIGN KEY (repository_id)
      REFERENCES Repositories(id),
    CONSTRAINT resource_reference_resources_repository 
      FOREIGN KEY (resource_id)
      REFERENCES Resources(id),
    PRIMARY KEY (repository_id, resource_id)
  );