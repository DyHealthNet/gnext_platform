# GNext Platform# GNExT Platform



A web-based platform for exploring GWAS (Genome-Wide Association Studies) results with integrated search and visualization capabilities.A comprehensive web platform for exploring and analyzing GWAS (Genome-Wide Association Studies) data with interactive visualizations, gene-based analysis, and variant lookups.



## Architecture

## ⚙️ Environment Configuration

The platform consists of three main services:

- **Typesense**: Fast search engine for phenotypes, genes, and variants### Single `.env` File Location

- **Backend**: Django REST API serving GWAS data and metadata

- **Frontend**: Vue.js single-page application with interactive visualizations**All environment variables are managed from a single `.env` file:**

```

---gnext_platform/.env

```

## Environmental Configuration

### How It Works

The platform uses a single `.env` file located at the root of `gnext_platform/` directory. This file contains all configuration variables for development and production deployments.

All services automatically read from the central `.env` file:

Key configuration variables include:

- **Study Configuration**: `STUDY_ACRONYM`, data paths, phenotype files| Component | Method |

- **Port Configuration**: `VITE_BACKEND_PORT`, `VITE_FRONTEND_PORT`, `VITE_TYPESENSE_PORT`|-----------|--------|

- **Typesense Settings**: API keys, host configuration, data directories| **Backend (Django)** | `python-decouple` automatically finds parent `.env` |

- **Data Paths**: `NF_DATA_DIR`, `PHENO_FILE`, `TYPESENSE_DATA_DIR`| **Frontend (Vue/Vite)** | `vite.config.js` configured to load from `'../'` |

- **Import Control**: `FORCE_TYPESENSE_RESET` (controls data re-import behavior)| **Docker Compose** | `env_file: - .env` relative to compose file |



> **Note**: Detailed descriptions of all environment variables will be added in future documentation.

### Required Environment Variables

---

Copy the example file and configure:

## Deployment for Development

```bash

### Prerequisitescd gnext_platform

- Docker and Docker Compose installedcp .env.example .env

- `.env` file configured with appropriate paths and settingsnano .env  # Edit with your paths and settings

```

### Steps

See `.env.example` for a complete list of variables with descriptions.

1. **Navigate to the platform directory**

   ```bash---

   cd gnext_platform/

   ```## 🏗️ Development



2. **Configure environment variables**### NPM Commands

   - Edit the `.env` file with your study-specific settings

   - Ensure `VITE_TYPESENSE_HOST=localhost` for development- **`npm run dev`** - Start development server with hot-reload (use this for local development)

   - Set appropriate port numbers that don't conflict with other services- **`npm run build`** - Build optimized production bundle

- **`npm run preview`** - Preview production build locally

3. **Start the services**

   ```bashFor development, always use `npm run dev`. The `build` command is used automatically in production Docker builds.

   docker-compose up -d

   ```### Development Setup



4. **Check service status**For local development without Docker Compose:

   ```bash

   docker-compose ps#### First Time Setup:

   ```

```bash

5. **View logs**# 1. Navigate to backend

   ```bashcd gnext_platform/gnext_backend

   # All services

   docker-compose logs -f# 2. Create and activate conda environment

   conda create -n gnext_backend python=3.11

   # Specific serviceconda activate gnext_backend

   docker-compose logs -f gnext-backendpip install -r requirements.txt

   docker-compose logs -f gnext-frontend

   docker-compose logs -f typesense# 3. Start Typesense container (pulls image with --pull)

   ```./setup_typesense_dev.sh --pull



6. **Access the application**# 4. Initialize Typesense data (only needed once or when data changes)

   - Frontend: `http://localhost:${VITE_FRONTEND_PORT}`python init_typesense.py

   - Backend API: `http://localhost:${VITE_BACKEND_PORT}`

   - Typesense: `http://localhost:${VITE_TYPESENSE_PORT}`# 5. Start backend (specify port matching VITE_BACKEND_PORT in .env)

python manage.py runserver 0.0.0.0:8300  # For olfaction

### Development Workflow# python manage.py runserver 0.0.0.0:8100  # For lipids



**When making code changes:**# 6. In new terminal - setup and start frontend

cd gnext_platform/gnext_frontend

1. **Backend changes** (Python/Django code):conda create -n gnext_frontend nodejs

   ```bashconda activate gnext_backend

   # Rebuild and restart backendnpm install

   docker-compose build gnext-backendnpm run dev

   docker-compose up -d gnext-backend```

   ```

#### Subsequent Development Sessions:

2. **Frontend changes** (Vue.js code):

   ```bash```bash

   # Rebuild and restart frontend# Terminal 1 - Backend

   docker-compose build gnext-frontendcd gnext_platform/gnext_backend

   docker-compose up -d gnext-frontendconda activate gnext_backend

   ```

# Start Typesense if not running

3. **Environment variable changes**:./setup_typesense_dev.sh

   ```bash

   # Recreate containers to reload .env# Start backend (specify port from .env - e.g., 8300 for olfaction, 8100 for lipids)

   docker-compose up -d --force-recreatepython manage.py runserver 0.0.0.0:8300

   ```

# Terminal 2 - Frontend

---cd gnext_platform/gnext_frontend

conda activate gnext_frontend

## Deployment for Productionnpm run dev

```

### Prerequisites

- Docker and Docker Compose installed**Access:**

- Production-ready `.env` file with secure credentials- Frontend: `http://localhost:5173` (or custom port from `VITE_FRONTEND_PORT`)

- Sufficient disk space for Typesense data volume- Backend API: `http://localhost:8000` (or custom port when running `python manage.py runserver 0.0.0.0:PORT`)

- Data files (phenotypes, genes, variants) accessible on the host- Typesense: `http://localhost:8108` (or custom port from `VITE_TYPESENSE_PORT`)



### Steps### Customizing Development Ports



1. **Prepare the environment**To use custom ports in development, add these to your `.env` file:

   ```bash

   cd gnext_platform/```bash

   ```# Development Ports

VITE_FRONTEND_PORT=5173      # Frontend dev server port

2. **Configure production environment**VITE_TYPESENSE_PORT=8108     # Typesense port

   - Edit `.env` with production settingsVITE_TYPESENSE_HOST=localhost

   - Ensure all data paths point to production data directories

   - Set secure `VITE_TYPESENSE_KEY`# Backend port is specified when running: python manage.py runserver 0.0.0.0:8000

   - Configure appropriate port numbersVITE_API_URL=http://localhost:8000  # Update if using different backend port

```

3. **Build images**

   ```bashThen start services normally:

   docker-compose build

   ``````bash

# Backend with custom port

4. **Start services**python manage.py runserver 0.0.0.0:8001

   ```bash

   docker-compose up -d# Typesense with custom port (edit .env first)

   ```VITE_TYPESENSE_PORT=8109 ./setup_typesense_dev.sh



5. **Verify deployment**# Frontend - automatically uses VITE_FRONTEND_PORT from .env

   ```bashnpm run dev

   # Check all containers are running```

   docker-compose ps

   ---

   # Check backend health

   curl http://localhost:${VITE_BACKEND_PORT}/api/health## 🚀 Production Deployment

   

   # Check Typesense health### NPM Commands Explained

   curl -H "X-TYPESENSE-API-KEY: ${VITE_TYPESENSE_KEY}" \

        http://localhost:${VITE_TYPESENSE_PORT}/health- **`npm run dev`** - Development mode with hot-reload (for local development)

   ```- **`npm run build`** - Build production-optimized bundle (for deployment)

- **`npm run preview`** - Preview production build locally (testing)

6. **Monitor logs**

   ```bashFor production with Docker Compose, the build happens inside the container automatically.

   docker-compose logs -f

   ```### Single Deployment



### Production UpdatesDeploy one instance by configuring the `.env` file:



**Deploying code updates:**```bash

cd gnext_platform

1. Pull latest changes from repository

2. Rebuild affected services:# Configure .env with study-specific settings

   ```bashcp .env.olfaction .env  # or .env.lipids, or create your own

   docker-compose build --no-cache <service-name>

   ```# Key variables to set:

3. Restart services:# STUDY_ACRONYM=olfaction  # Used for container names

   ```bash# BACKEND_PORT=8300

   docker-compose up -d# FRONTEND_PORT=8400

   ```# TYPESENSE_PORT=8308



---# Deploy (uses single docker-compose.yml)

docker-compose up -d --build

## Typesense Data Management```



### Initial Setup (Empty Typesense)**Result:**

- Container names: `gnext-backend-olfaction`, `gnext-frontend-olfaction`, `gnext-typesense-olfaction`

When deploying for the first time or with an empty Typesense volume:- Network: `gnext-olfaction`

- Frontend: `http://server:8400`

1. **Ensure data files are accessible**- Backend: `http://server:8300`

   - Phenotype file at `${PHENO_FILE}`- Typesense: `http://server:8308`

   - Gene mappings at `${NF_DATA_DIR}/lmdb_gene/mapped_genes.tsv`

   - Annotated variants at `${NF_DATA_DIR}/annotate/full_variants.vcf.gz`### Multiple Deployments (Olfaction + Lipids)



2. **Set import flag** (optional, enabled by default on empty collection)Run both instances simultaneously - each with different `STUDY_ACRONYM` and ports:

   ```bash

   # In .env file```bash

   FORCE_TYPESENSE_RESET=falsecd gnext_platform

   ```

# Deploy olfaction

3. **Start services**cp .env.olfaction .env

   ```bashdocker-compose up -d --build

   docker-compose up -d

   ```# Deploy lipids (same docker-compose.yml, different .env)

cp .env.lipids .env

4. **Monitor import progress**docker-compose up -d --build

   ```bash```

   docker logs -f gnext-backend-${STUDY_ACRONYM}

   ```**Result:**



The backend will automatically:| Study | Containers | Ports |

- Wait for Typesense to be ready|-------|-----------|-------|

- Create the collection schema| **Olfaction** | `gnext-*-olfaction` | Frontend: 8400, Backend: 8300, Typesense: 8308 |

- Import phenotypes, genes, and variants| **Lipids** | `gnext-*-lipids` | Frontend: 8200, Backend: 8100, Typesense: 8208 |

- Start serving requests once complete

**Access:**

**Expected import times:**- **Olfaction:** `http://server:8400` (frontend), `http://server:8300` (backend)

- Phenotypes: seconds- **Lipids:** `http://server:8200` (frontend), `http://server:8100` (backend)

- Genes: ~1-2 minutes

- Variants: varies by dataset size (can take 10-30+ minutes for large datasets)**Advantages:**

- ✅ Same `docker-compose.yml` for all deployments

### Re-importing Data (Existing Typesense)- ✅ Only `.env` file changes between studies

- ✅ Container names automatically include study identifier

When Typesense already contains data but you need to refresh it:- ✅ No port conflicts - each study uses different ports

- ✅ Easy to add new studies (just create new `.env.newstudy`)

1. **Set the force reset flag**

   ```bash### Creating a New Study Deployment

   # In .env file

   FORCE_TYPESENSE_RESET=trueTo add a new study (e.g., "ukbb"):

   ```

```bash

2. **Rebuild and restart backend**# 1. Create .env file for the study

   ```bashcp .env.example .env.ukbb

   docker-compose build --no-cache gnext-backend

   docker-compose up -d gnext-backend# 2. Edit key settings

   ```nano .env.ukbb

```

3. **Monitor the re-import**

   ```bashRequired settings:

   docker logs -f gnext-backend-${STUDY_ACRONYM}```bash

   ```STUDY_ACRONYM=ukbb              # Unique identifier

BACKEND_PORT=8500               # Unique port

4. **After import completes, disable force reset**FRONTEND_PORT=8600              # Unique port  

   ```bashTYPESENSE_PORT=8508             # Unique port

   # In .env filePHENO_FILE=/path/to/ukbb/pheno_file.csv

   FORCE_TYPESENSE_RESET=falseNF_DATA_DIR=/path/to/ukbb/nextflow_output

   ```TYPESENSE_DATA_DIR=/path/to/ukbb/typesense_volume

```

5. **Restart backend to apply change**

   ```bash```bash

   docker-compose restart gnext-backend# 3. Deploy

   ```cp .env.ukbb .env

docker-compose up -d --build

> **Important**: The `FORCE_TYPESENSE_RESET=true` flag will delete all existing data and re-import. Always set it back to `false` after the import completes to prevent unnecessary re-imports on subsequent restarts.```



### Clearing Typesense DataResult: Containers `gnext-*-ukbb` on ports 8500/8600/8508



To completely clear Typesense and start fresh:Docker Compose automatically:

- ✅ Pulls Typesense image (`typesense/typesense:29.0.rc15`)

1. **Stop all services**- ✅ Builds backend & frontend images (runs `npm run build` for frontend)

   ```bash- ✅ Creates networks automatically with study-specific names

   docker-compose down- ✅ Names all containers with `STUDY_ACRONYM` suffix

   ```- ✅ Runs `init_typesense.py` to import data

- ✅ Starts all services on configured ports

2. **Remove the Typesense volume**

   ```bash### Common Operations

   sudo rm -rf ${TYPESENSE_DATA_DIR}/*

   ``````bash

cd gnext_platform

3. **Restart services**

   ```bash# View logs for specific study

   docker-compose up -ddocker-compose logs -f

   ```

# View specific container (replace {study} with your STUDY_ACRONYM)

The backend will detect the empty collection and automatically import data.docker logs gnext-backend-{study}

docker logs gnext-frontend-{study}

### Skipping Import (Data Already Present)docker logs gnext-typesense-{study}



If Typesense already has data and you don't want to re-import:# Restart a specific service

docker-compose restart gnext-backend

1. **Ensure force reset is disabled**

   ```bash# Rebuild after code changes

   # In .env filedocker-compose up -d --build

   FORCE_TYPESENSE_RESET=false

   ```# Stop all services for current study

docker-compose down

2. **Start services normally**

   ```bash# Re-initialize Typesense data only

   docker-compose up -ddocker exec -it gnext-backend-{study} python init_typesense.py

   ```

# List all running study deployments

The backend will detect existing data and skip the import process, starting immediately.docker ps | grep gnext



---# Stop specific study deployment

# First switch to that study's .env, then:

## Troubleshootingcp .env.olfaction .env

docker-compose down

### Container Issues```

- ✅ Starts Typesense containers

**Check container status:**- ✅ Runs `init_typesense.py` (imports all data)

```bash- ✅ Starts all services on configured ports

docker-compose ps

```

**View logs:**
```bash
# All services
docker-compose logs -f

# Specific service
docker logs gnext-backend-${STUDY_ACRONYM}
docker logs gnext-frontend-${STUDY_ACRONYM}
docker logs gnext-typesense-${STUDY_ACRONYM}
```

**Restart a service:**
```bash
docker-compose restart <service-name>
```

**Rebuild after code changes:**
```bash
docker-compose build --no-cache <service-name>
docker-compose up -d <service-name>
```

### Network Issues

**Test backend-to-typesense connectivity:**
```bash
docker exec gnext-backend-${STUDY_ACRONYM} curl -v http://typesense:8108/health
```

**Test frontend-to-backend connectivity:**
```bash
docker exec gnext-frontend-${STUDY_ACRONYM} curl -v http://gnext-backend-${STUDY_ACRONYM}:8000/api/
```

### Data Import Issues

**File not found errors:**
- Verify paths in `.env` are correct
- Ensure data files exist on the host system
- Check volume mounts in `docker-compose.yml`

**Symlink errors:**
- Replace symlinks with actual files in the data directory
- Use: `find . -type l -exec sh -c 'target=$(readlink -f "$1"); if [ -f "$target" ]; then cp --remove-destination "$target" "$1"; fi' _ {} \;`

**Import taking too long:**
- Check Docker resource limits (CPU, memory)
- Monitor system resources: `docker stats`
- Variants import is expected to take considerable time for large datasets

**Import keeps restarting:**
- Set `FORCE_TYPESENSE_RESET=false` in `.env`
- Rebuild backend: `docker-compose build --no-cache gnext-backend`
- Restart: `docker-compose up -d gnext-backend`

### Performance Issues

**Slow search queries:**
- Check Typesense memory allocation
- Verify Typesense data volume is on fast storage (SSD preferred)
- Monitor: `docker stats gnext-typesense-${STUDY_ACRONYM}`

**High memory usage:**
- Adjust Gunicorn workers in `docker-compose.yml` command
- Increase Docker memory limits if needed

---

## Maintenance

### Backup

**Backup Typesense data:**
```bash
tar -czf typesense-backup-$(date +%Y%m%d).tar.gz ${TYPESENSE_DATA_DIR}
```

**Backup environment configuration:**
```bash
cp .env .env.backup-$(date +%Y%m%d)
```

### Updates

**Update base images:**
```bash
docker-compose pull
docker-compose up -d
```

**Update application code:**
```bash
git pull
docker-compose build --no-cache
docker-compose up -d
```

### Cleanup

**Remove unused Docker resources:**
```bash
docker system prune -a
```

**Remove old images:**
```bash
docker images | grep gnext | grep -v latest | awk '{print $3}' | xargs docker rmi
```

---

## Study-Specific Deployments

The platform supports multiple study deployments on the same host using the `STUDY_ACRONYM` variable:

1. Create separate `.env` files for each study (e.g., `.env.olfaction`, `.env.lipids`)
2. Deploy with specific env file:
   ```bash
   docker-compose --env-file .env.olfaction up -d
   ```

Each deployment will have isolated:
- Container names (e.g., `gnext-backend-olfaction`)
- Networks (e.g., `gnext-olfaction`)
- Data volumes
- Port mappings

This allows running multiple studies simultaneously on the same server.

---

## License

See [LICENSE](LICENSE) file for details.
