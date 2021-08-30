FROM ubuntu

# Environment and build variables
ENV ECLIPSE_INSTALLER_DIR=/opt/eclipse-installer
ENV STM32CUBEIDE_DIR=/opt/stm32cubeide

ARG ECLIPSE_P2_APP=org.eclipse.equinox.p2.director
ARG ST_REPOSITORY=https://sw-center.st.com/stm32cubeide/updatesite1

ARG STM32CUBEIDE_IU=com.st.stm32cube.ide.mcu.rcp.product
ARG ARM_TOOLCHAIN_DEFINITION=com.st.stm32cube.ide.feature.mcu.toolchain.arm_none.feature.group
ARG LINKER_SCRIPT_FILE_EDITOR_IU=com.st.stm32cube.ide.feature.mcu.linker.ui.feature.group
ARG C_GCC_CROSS_COMPILER_SUPPORT_IU=org.eclipse.cdt.build.crossgcc.feature.group
ARG C_ARM_CROSS_COMPILER_IU=org.eclipse.embedcdt.managedbuild.cross.arm.feature.group
ARG C_CORE_IU=org.eclipse.embedcdt.feature.group

# Install requirements
RUN apt-get update && apt-get install -y wget tar openssh-client default-jre

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
-installIU ${C_ARM_CROSS_COMPILER_IU},${C_CORE_IU}
