# users
- name: string 

# tasks
- title: string
- content: string
- deadline: date
- priority: integer
- status: integer

# labels
- label_name: string

# my_tasks
- user_id (FK)
- task_id (FK)

# labelings
- task_id (FK)
- label_id (FK)