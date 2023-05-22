TRAIN_IMAGE ?= gcr.io/vcm-ml/fv3fit:zc-manuscript-submission
RUN_IMAGE ?= gcr.io/vcm-ml/prognostic_run:zc-manuscript-submission

DOCKER_ARGS = \
	-v $(shell pwd)/data:/data \
	-v $(shell pwd)/outputs:/outputs \
	-v $(shell pwd)/models:/models \
	-v $(shell pwd)/code:/code \
	-w /code

PROG_DOCKER_ARGS = -v $(shell pwd)/fv3gfs_inputs:/fv3gfs_inputs ${DOCKER_ARGS}

enter_training:
	docker run $(DOCKER_ARGS) --interactive --tty $(TRAIN_IMAGE) bash

train_%:
	docker run $(DOCKER_ARGS) -w /code $(TRAIN_IMAGE) \
		python3 -m fv3fit.train_microphysics \
			--config-path /code/training/$*.yaml

train_models: train_gscond_classifier train_gscond train_precpd

enter_prognostic:
	docker run $(PROG_DOCKER_ARGS) --interactive --tty $(RUN_IMAGE) bash


create_training_%:

	docker run $(PROG_DOCKER_ARGS) $(RUN_IMAGE) bash -c "scripts/train_month.sh $*"

# Create training data sampling from all months of the year
# Much faster if it can be farmed out as jobs
# Creates a lot of data
create_training_allmonths: (create_training_01 \
	create_training_02 \
	create_training_03 \
	create_training_04 \
	create_training_05 \
	create_training_06 \
	create_training_07 \
	create_training_08 \
	create_training_09 \
	create_training_10 \
	create_training_11 \
	create_training_12 )

gather_training:
	code/scripts/gather_training_netcdfs.sh

run_30_day_july:
	mkdir -p outputs/30_day_july
	docker run $(PROG_DOCKER_ARGS) $(RUN_IMAGE) prepare-config /code/simulation/online-emulation-30day.yaml > outputs/30_day_july/fv3config.yaml
	docker run $(PROG_DOCKER_ARGS) $(RUN_IMAGE) runfv3 run-native /outputs/30_day_july/fv3config.yaml /outputs/30_day_july/rundir

# Creates a lot of data
run_1yr:
	mkdir -p outputs/1yr
	docker run $(PROG_DOCKER_ARGS) $(RUN_IMAGE) prepare-config /code/simulation/online-emulation-1year.yaml > outputs/1yr/fv3config.yaml
	docker run $(PROG_DOCKER_ARGS) $(RUN_IMAGE) runfv3 run-native /outputs/1yr/fv3config.yaml /outputs/1yr/rundir

clean_outputs:
	sudo rm -rf outputs/1yr outputs/30_day_july outputs/training_rundirs
