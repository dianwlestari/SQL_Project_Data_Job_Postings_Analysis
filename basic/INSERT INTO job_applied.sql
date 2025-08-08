INSERT INTO job_applied (
    job_id, 
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status)

values (
    1, 
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'),
    (
     2,
     '2024-02-02',
     true,
     'resume_02.pdf',
     true,
     'cover_letter_02.pdf',
     'submitted'),
     (
     3,
     '2024-02-03',
     true,
     'resume_03.pdf',
     true,
     'cover_letter_03.pdf',
     'submitted');

select*from job_applied;

select DISTINCT * from job_applied;

 