-- SkillNova Freelance Job Marketplace schema (MySQL 8+)
CREATE DATABASE IF NOT EXISTS skillnova;
USE skillnova;

CREATE TABLE IF NOT EXISTS roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    account_status ENUM('PENDING','ACTIVE','SUSPENDED','REJECTED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE IF NOT EXISTS client_profiles (
    user_id BIGINT PRIMARY KEY,
    company_name VARCHAR(120),
    company_website VARCHAR(255),
    company_bio TEXT,
    CONSTRAINT fk_client_profile_user FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS freelancer_profiles (
    user_id BIGINT PRIMARY KEY,
    headline VARCHAR(160),
    years_experience INT NOT NULL DEFAULT 0,
    hourly_rate DECIMAL(10,2),
    freelancer_bio TEXT,
    CONSTRAINT chk_freelancer_experience CHECK (years_experience >= 0),
    CONSTRAINT fk_freelancer_profile_user FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS freelancer_skills (
    user_id BIGINT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (user_id, skill_id),
    CONSTRAINT fk_freelancer_skills_user FOREIGN KEY (user_id) REFERENCES freelancer_profiles(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_freelancer_skills_skill FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS jobs (
    job_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    client_id BIGINT NOT NULL,
    job_title VARCHAR(160) NOT NULL,
    job_description TEXT NOT NULL,
    budget_min DECIMAL(10,2) NOT NULL,
    budget_max DECIMAL(10,2) NOT NULL,
    experience_level ENUM('ENTRY','INTERMEDIATE','EXPERT') NOT NULL DEFAULT 'ENTRY',
    location_type ENUM('REMOTE','ONSITE','HYBRID') NOT NULL DEFAULT 'REMOTE',
    job_status ENUM('OPEN','CLOSED','CANCELLED') NOT NULL DEFAULT 'OPEN',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_job_budget_range CHECK (budget_max >= budget_min),
    CONSTRAINT fk_jobs_client FOREIGN KEY (client_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS job_skills (
    job_id BIGINT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (job_id, skill_id),
    CONSTRAINT fk_job_skills_job FOREIGN KEY (job_id) REFERENCES jobs(job_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_job_skills_skill FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applications (
    application_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_id BIGINT NOT NULL,
    freelancer_id BIGINT NOT NULL,
    cover_letter TEXT,
    proposed_budget DECIMAL(10,2),
    estimated_days INT,
    application_status ENUM('APPLIED','SHORTLISTED','REJECTED','HIRED','WITHDRAWN') NOT NULL DEFAULT 'APPLIED',
    applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_job_freelancer_application UNIQUE (job_id, freelancer_id),
    CONSTRAINT chk_estimated_days CHECK (estimated_days IS NULL OR estimated_days > 0),
    CONSTRAINT fk_applications_job FOREIGN KEY (job_id) REFERENCES jobs(job_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_applications_freelancer FOREIGN KEY (freelancer_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
    review_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_id BIGINT NOT NULL,
    reviewer_user_id BIGINT NOT NULL,
    reviewee_user_id BIGINT NOT NULL,
    rating TINYINT NOT NULL,
    review_comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_review_per_job_pair UNIQUE (job_id, reviewer_user_id, reviewee_user_id),
    CONSTRAINT chk_rating_range CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT fk_reviews_job FOREIGN KEY (job_id) REFERENCES jobs(job_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_reviews_reviewer FOREIGN KEY (reviewer_user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_reviews_reviewee FOREIGN KEY (reviewee_user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS wishlisted_jobs (
    user_id BIGINT NOT NULL,
    job_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, job_id),
    CONSTRAINT fk_wishlist_user FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_job FOREIGN KEY (job_id) REFERENCES jobs(job_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS contact_messages (
    message_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    sender_name VARCHAR(120) NOT NULL,
    sender_email VARCHAR(120) NOT NULL,
    subject VARCHAR(180) NOT NULL,
    message_body TEXT NOT NULL,
    message_status ENUM('NEW','IN_PROGRESS','RESOLVED') NOT NULL DEFAULT 'NEW',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_contact_user FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE SET NULL
);

INSERT INTO roles (role_name)
SELECT 'ADMIN' WHERE NOT EXISTS (SELECT 1 FROM roles WHERE role_name = 'ADMIN');

INSERT INTO roles (role_name)
SELECT 'CLIENT' WHERE NOT EXISTS (SELECT 1 FROM roles WHERE role_name = 'CLIENT');

INSERT INTO roles (role_name)
SELECT 'FREELANCER' WHERE NOT EXISTS (SELECT 1 FROM roles WHERE role_name = 'FREELANCER');
