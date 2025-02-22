# LeiSearch

LeiSearch is a toy project I built to learn Elixir by working with real-world data. The goal is to fetch the latest Legal Entity Identifier (LEI) data, transform it, and make it easily searchable. Along the way, I want to explore Elixir's strengths in concurrent data processing, API serving, and database choices.

## Features
- **Fetch Latest LEI Data**: Downloads and extracts the official LEI dataset from GLEIF.
- **Transform and Build Relationships**: Parses the CSV, processes entities, and structures data for efficient querying.
- **Make Data Easily Searchable**: Provides a way to query entities based on LEI and related attributes.


## Learning Goals
This project is helping me explore:
- **Elixir for concurrent data processing**: Handling large datasets efficiently.
- **Building and serving an API**: Using Phoenix effectively.
- **Storage decisions**: Evaluating PostgreSQL, Neo4j, or an alternative.
- Functional programming in a real-world scenario.
- **Efficient search and query strategies**: Exploring how different storage solutions affect query performance.

## Roadmap

**Completed**
- [x] Download and extract the LEI dataset
- [x] Parse CSV files and extract relevant fields
- [x] Basic data transformation (converting CSV into structured data)

**Next**
- [ ] Improve transformation logic and data validation
- [ ] Decide on a database backend (PostgreSQL vs. Neo4j vs. another option)
- [ ] Implement a simple search mechanism for LEIs and related attributes
- [ ] Expose a REST or GraphQL API for querying LEI data

**Maybe**
- [ ] Optimize data ingestion for larger datasets (streaming, batching, etc.)
- [ ] Implement indexing for faster lookups
- [ ] Build a frontend UI for searching LEIs
- [ ] Support filtering and faceted search features
- [ ] Deploy the service for external usage


## License
This project is licensed under the MIT License.
