FROM ubuntu

# Environment and build variables
ENV ECLIPSE_INSTALLER_DIR=/opt/eclipse-installer
ENV STM32CUBEIDE_DIR=/opt/stm32cubeide

ENV ECLIPSE_P2_APP=org.eclipse.equinox.p2.director
ENV ST_REPOSITORY=https://sw-center.st.com/stm32cubeide/updatesite1

ENV STM32CUBEIDE_IU=com.st.stm32cube.ide.mcu.rcp.product
ENV ARM_TOOLCHAIN_DEFINITION_IU=com.st.stm32cube.ide.feature.mcu.toolchain.arm_none.feature.group
ENV LINKER_SCRIPT_FILE_EDITOR_IU=com.st.stm32cube.ide.feature.mcu.linker.ui.feature.group
ENV C_GCC_CROSS_COMPILER_SUPPORT_IU=org.eclipse.cdt.build.crossgcc.feature.group
ENV C_ARM_CROSS_COMPILER_IU=org.eclipse.embedcdt.managedbuild.cross.arm.feature.group
ENV C_CORE_IU=org.eclipse.embedcdt.feature.group

# Install requirements
RUN apt-get update && apt-get install -y wget tar openssh-client default-jre libxml2-utils

# Install Eclipse
RUN wget "https://mirror.ibcp.fr/pub/eclipse/oomph/epp/2021-06/R/eclipse-inst-jre-linux64.tar.gz" -P /home
RUN tar xvfz /home/eclipse-*tar.gz -C /opt && rm /home/eclipse-*tar.gz

# Install STM32CubeIDE
RUN ${ECLIPSE_INSTALLER_DIR}/eclipse-inst \
-application ${ECLIPSE_P2_APP} \
-repository ${ST_REPOSITORY} \
-installIU ${STM32CUBEIDE_IU} \
-destination ${STM32CUBEIDE_DIR}

RUN ${STM32CUBEIDE_DIR}/stm32cubeide \
-application ${ECLIPSE_P2_APP} \
-repository ${ST_REPOSITORY} \
-installIU ${ARM_TOOLCHAIN_DEFINITION_IU},${LINKER_SCRIPT_FILE_EDITOR_IU},${C_GCC_CROSS_COMPILER_SUPPORT_IU},${C_ARM_CROSS_COMPILER_IU},${C_CORE_IU}

# Aliases
ARG LIST_UI_CMD='ListIu=$($STM32CUBEIDE_DIR/stm32cubeide -application $ECLIPSE_P2_APP -lir);\
ListIu=${ListIu/"$STM32CUBEIDE_IU"/STM32CUBEIDE};\
ListIu=${ListIu/"$ARM_TOOLCHAIN_DEFINITION_IU"/ARM_TOOLCHAIN_DEFINITION};\
ListIu=${ListIu/"$LINKER_SCRIPT_FILE_EDITOR_IU"/LINKER_SCRIPT_FILE_EDITOR};\
ListIu=${ListIu/"$C_GCC_CROSS_COMPILER_SUPPORT_IU"/C_GCC_CROSS_COMPILER_SUPPORT};\
ListIu=${ListIu/"$C_ARM_CROSS_COMPILER_IU"/C_ARM_CROSS_COMPILER};\
ListIu=${ListIu/"$C_CORE_IU"/C_CORE};\
echo "$ListIu"'
ARG UPDATE_CMD='$STM32CUBEIDE_DIR/stm32cubeide -application $ECLIPSE_P2_APP -repository $ST_REPOSITORY -installIU $STM32CUBEIDE_IU || { rm -R $STM32CUBEIDE_DIR; $ECLIPSE_INSTALLER_DIR/eclipse-inst -application $ECLIPSE_P2_APP -repository $ST_REPOSITORY -installIU $STM32CUBEIDE_IU -destination $STM32CUBEIDE_DIR; };\
$STM32CUBEIDE_DIR/stm32cubeide -application $ECLIPSE_P2_APP -repository $ST_REPOSITORY -installIU $ARM_TOOLCHAIN_DEFINITION_IU,$LINKER_SCRIPT_FILE_EDITOR_IU,$C_GCC_CROSS_COMPILER_SUPPORT_IU,${C_ARM_CROSS_COMPILER_IU},${C_CORE_IU}'
ARG GET_IDE_LOCAL_VERSION='$STM32CUBEIDE_DIR/stm32cubeide -application $ECLIPSE_P2_APP -lir | grep "$STM32CUBEIDE_IU/" | sed -e "s/$STM32CUBEIDE_IU\///g"'
ARG GET_IDE_REMOTE_VERSION='$STM32CUBEIDE_DIR/stm32cubeide -application $ECLIPSE_P2_APP -repository $ST_REPOSITORY -l 2>/dev/null | grep "$STM32CUBEIDE_IU=" | sed -e "s/$STM32CUBEIDE_IU=//g" | tail -n1'

RUN echo "#!/bin/bash\n$LIST_UI_CMD" > /usr/bin/stcubeide_listUI && chmod +x /usr/bin/stcubeide_listUI
RUN echo "#!/bin/bash\n$UPDATE_CMD" > /usr/bin/stcubeide_update && chmod +x /usr/bin/stcubeide_update
RUN echo "#!/bin/bash\n$GET_IDE_LOCAL_VERSION" > /usr/bin/stcubeide_getLocalVersion && chmod +x /usr/bin/stcubeide_getLocalVersion
RUN echo "#!/bin/bash\n$GET_IDE_REMOTE_VERSION" > /usr/bin/stcubeide_getRemoteVersion && chmod +x /usr/bin/stcubeide_getRemoteVersion
