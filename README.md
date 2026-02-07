# QueryLens Testbed

A Rails 8 app for testing the [QueryLens](https://github.com/bryanbeshore/query_lens) engine gem — a natural language SQL query builder powered by AI.

This app provides a realistic small SaaS dataset (users, teams, posts, comments, tags, invoices) and a dashboard UI so you can visually inspect the data and then query it via QueryLens.

## Setup

```bash
git clone https://github.com/bryanbeshore/query_lens_testbed.git
cd query_lens_testbed

# Clone the QueryLens engine alongside this app
cd .. && git clone https://github.com/bryanbeshore/query_lens.git && cd query_lens_testbed

bundle install
bin/rails db:prepare   # creates DB, runs migrations, seeds data
```

## Running

```bash
# Option 1: Inline (key stays out of your shell history on some shells)
ANTHROPIC_API_KEY=sk-ant-your-key-here bin/dev

# Option 2: Export first (persists for the whole terminal session)
export ANTHROPIC_API_KEY=sk-ant-your-key-here
bin/dev
```

- **Dashboard:** [localhost:3000](http://localhost:3000) — overview of all seed data
- **QueryLens:** [localhost:3000/query_lens](http://localhost:3000/query_lens) — natural language query interface

## Schema

| Model      | Records | Notes                                          |
|------------|--------:|-------------------------------------------------|
| User       |      50 | 5 admins, 45 members                           |
| Team       |      10 | mixed plans: free, starter, pro, enterprise    |
| Membership |      81 | roles: owner, admin, member                    |
| Post       |     200 | 120 published, 40 draft, 40 archived           |
| Comment    |     500 |                                                 |
| Tag        |      15 | engineering, product, design, marketing, etc.  |
| PostTag    |     500 | many-to-many join table                        |
| Invoice    |     100 | 60 paid, 20 pending, 20 overdue                |

## Test Prompts for QueryLens

Use these in the QueryLens UI to exercise different SQL generation capabilities:

### Basic queries
1. `Show me all admin users`
2. `How many posts are published vs draft vs archived?`
3. `List all teams on the pro plan`

### Joins / relationships
4. `Which users have the most comments?`
5. `Show me all posts tagged with "engineering"`
6. `List team members of Acme Corp with their roles`

### Aggregations
7. `What is the total invoice amount by team?`
8. `How many posts does each team have, sorted by most to least?`
9. `Show the average invoice amount per plan type`

### Filtering + date logic
10. `Show all overdue invoices with their team name and amount`
11. `Which users posted in the last 30 days?`
12. `Find teams that have both paid and overdue invoices`

### Complex / multi-join
13. `Show me users who are members of more than one team`
14. `What are the top 5 most-used tags across published posts?`
15. `For each team, show the number of members, posts, and total invoice revenue`

## Configuration

The QueryLens initializer is at `config/initializers/query_lens.rb`:

- **Model:** `claude-sonnet-4-5-20250929`
- **Auth:** open (allows all requests)
- **API key:** reads from `ENV["ANTHROPIC_API_KEY"]`

## Tech Stack

- Rails 8.1, Ruby 3.4
- PostgreSQL
- QueryLens engine (local gem at `../query_lens`)
- RubyLLM + Anthropic Claude
