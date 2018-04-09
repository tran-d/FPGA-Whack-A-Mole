	component debugger is
		port (
			probe : in std_logic_vector(31 downto 0) := (others => 'X')  -- probe
		);
	end component debugger;

	u0 : component debugger
		port map (
			probe => CONNECTED_TO_probe  -- probes.probe
		);

